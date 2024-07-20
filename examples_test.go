// These end-to-end tests run Goose over complete packages and test the Coq
// output.
//
// The examples are packages in internal/examples/.
// Tests in package pkg have a Ast pkg.gold.v with the expected Coq output.
// The Ast is generated by freezing the output of goose and then some manual
// auditing. They serve especially well as regression tests when making
// changes that are expected to have no impact on existing working code,
// and also conveniently are continuously-checked examples of goose output.
//
// There are also negative examples in testdata/ that goose rejects due to
// unsupported Go code. These are each run as a standalone package.
package goose_test

import (
	"bufio"
	"bytes"
	"errors"
	"flag"
	"fmt"
	"os"
	"path"
	"regexp"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/tchajed/goose"
)

var updateGold = flag.Bool("update-gold",
	false,
	"update *.gold.v files in internal/examples/ with current output")

type test struct {
	name string
	path string
}

func newTest(dir string, name string) test {
	return test{name: path.Base(name), path: path.Join(dir, name)}
}

func loadTests(dir string) []test {
	f, err := os.Open(dir)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	names, err := f.Readdirnames(0)
	if err != nil {
		panic(err)
	}
	var tests []test
	for _, n := range names {
		tests = append(tests, newTest(dir, n))
	}
	return tests
}

func (t test) isDir() bool {
	info, _ := os.Stat(t.path)
	return info.IsDir()
}

// A positiveTest is a test organized as a directory with expected Coq output
//
// Each test is a single Go package in dir that has a Ast <dir>.gold.v
// with the expected Coq output.
type positiveTest struct {
	test
}

// GoldFile returns the path to the test's gold Coq output
func (t positiveTest) GoldFile() string {
	return path.Join(t.path, t.name+".gold.v")
}

// ActualFile returns the path to the test's actual output
func (t positiveTest) ActualFile() string {
	return path.Join(t.path, t.name+".actual.v")
}

// Gold returns the contents of the gold Ast as a string
func (t positiveTest) Gold() string {
	expected, err := os.ReadFile(t.GoldFile())
	if err != nil {
		return ""
	}
	return string(expected)
}

// UpdateGold updates the gold output with real results
func (t positiveTest) UpdateGold(actual string) {
	err := os.WriteFile(t.GoldFile(), []byte(actual), 0644)
	if err != nil {
		panic(err)
	}
}

// PutActual updates the actual test output with the real results
func (t positiveTest) PutActual(actual string) {
	err := os.WriteFile(t.ActualFile(), []byte(actual), 0644)
	if err != nil {
		panic(err)
	}
}

// DeleteActual deletes the actual test output, if it exists
func (t positiveTest) DeleteActual() {
	_ = os.Remove(t.ActualFile())
}

func TestExamples(testingT *testing.T) {
	tests := loadTests("./testdata/examples")
	for _, t := range tests {
		t := positiveTest{t}
		if !t.isDir() {
			continue
		}
		testingT.Run(t.name, func(testingT *testing.T) {
			testingT.Parallel()
			assert := assert.New(testingT)
			files, errs, patternError := goose.TranslatePackages(t.path, ".")
			if patternError != nil {
				// shouldn't be possible since "." is valid
				assert.FailNowf("loading failed", "load error: %v", patternError)
			}
			if !(len(files) == 1 && len(errs) == 1) {
				assert.FailNowf("pattern matched unexpected number of packages",
					"files: %v", files)
			}

			var b bytes.Buffer
			files[0].Write(&b)
			actual := b.String()

			expected := t.Gold()
			if *updateGold {
				if actual != expected {
					fmt.Fprintf(os.Stderr, "updated %s\n", t.GoldFile())
				}
				t.UpdateGold(actual)
				t.DeleteActual()
				return
			}

			if expected == "" {
				assert.FailNowf("could not load gold output",
					"gold file: %s",
					t.GoldFile())
			}
			if actual != expected {
				t.PutActual(actual)
				assert.FailNowf("actual Coq output != gold output",
					"see %s",
					t.ActualFile())
				return
			}
			// when tests pass, clean up actual output
			t.DeleteActual()
		})
	}
}

type errorExpectation struct {
	Line  int
	Error string
}

type errorTestResult struct {
	Err        *goose.ConversionError
	ActualLine int
	Expected   errorExpectation
}

func getExpectedError(pkgDir string) *errorExpectation {
	errRegex := regexp.MustCompile(`ERROR ?(.*)`)
	f, err := os.Open(pkgDir)
	if err != nil {
		panic(err)
	}
	fileNames, err := f.Readdirnames(0)
	if err != nil {
		panic(err)
	}
	for _, name := range fileNames {
		file, err := os.Open(path.Join(pkgDir, name))
		if err != nil {
			panic(err)
		}
		scanner := bufio.NewScanner(file)
		lineNum := 0
		for scanner.Scan() {
			lineNum += 1
			ms := errRegex.FindStringSubmatch(scanner.Text())
			if ms == nil {
				continue
			}
			expected := &errorExpectation{Line: lineNum}
			// found a match
			if len(ms) > 1 {
				expected.Error = ms[1]
			}
			// only use the first ERROR
			return expected
		}
	}
	return nil
}

func getFirstConversionError(err error) *goose.ConversionError {
	var cerr *goose.ConversionError
	var merr goose.MultipleErrors
	if errors.As(err, &merr) {
		if errors.As(merr[0], &cerr) {
		} else {
			panic("Cannot convert to ConversionError")
		}
	} else {
		panic("Cannot convert")
	}
	return cerr
}

func TestNegativeExamples(testingT *testing.T) {
	tests := loadTests("./testdata/negative-tests")
	for _, t := range tests {
		if !t.isDir() {
			continue
		}
		testingT.Run(t.name, func(testingT *testing.T) {
			testingT.Parallel()
			assert := assert.New(testingT)
			files, errs, patternError := goose.TranslatePackages(t.path, ".")

			if patternError != nil { // shouldn't be possible since "." is valid
				assert.FailNowf("loading failed", "load error: %v", patternError)
			}
			conversionErr := getFirstConversionError(errs[0])
			expectedErr := getExpectedError(t.path)

			if !(len(files) == 1 && len(errs) == 1) {
				assert.FailNowf("pattern matched unexpected number of packages",
					"files: %v", files)
			}

			assert.Regexp(`(unsupported|future)`, conversionErr.Category)
			if !strings.Contains(conversionErr.Message, expectedErr.Error) {
				assert.FailNowf("incorrect error message",
					`%s: error message "%s" does not contain "%s"`,
					t.name, conversionErr.Message, expectedErr.Error)
			}
			actualLine := conversionErr.Position.Line
			if actualLine > 0 && actualLine != expectedErr.Line {
				assert.FailNowf("incorrect error message line",
					"%s: error is incorrectly attributed to %s",
					t.name, conversionErr.Position.String())
			}
		})
	}
}
