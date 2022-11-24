// Code generated by goose/cmd/test_gen DO NOT EDIT.
package semantics

import (
	"testing"

	"github.com/stretchr/testify/suite"
	"github.com/tchajed/goose/machine/disk"
)

type GoTestSuite struct {
	suite.Suite
}

func (suite *GoTestSuite) TestAllocateDistinct() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAllocateDistinct())
}

func (suite *GoTestSuite) TestAllocateFull() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAllocateFull())
}

func (suite *GoTestSuite) TestClosureBasic() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testClosureBasic())
}

func (suite *GoTestSuite) TestCompareAll() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCompareAll())
}

func (suite *GoTestSuite) TestCompareGT() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCompareGT())
}

func (suite *GoTestSuite) TestCompareGE() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCompareGE())
}

func (suite *GoTestSuite) TestCompareLT() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCompareLT())
}

func (suite *GoTestSuite) TestCompareLE() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCompareLE())
}

func (suite *GoTestSuite) TestByteSliceToString() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testByteSliceToString())
}

func (suite *GoTestSuite) TestCopySimple() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCopySimple())
}

func (suite *GoTestSuite) TestCopyShorterDst() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCopyShorterDst())
}

func (suite *GoTestSuite) TestCopyShorterSrc() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCopyShorterSrc())
}

func (suite *GoTestSuite) TestEncDec32Simple() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testEncDec32Simple())
}

func (suite *GoTestSuite) TestEncDec32() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testEncDec32())
}

func (suite *GoTestSuite) TestEncDec64Simple() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testEncDec64Simple())
}

func (suite *GoTestSuite) TestEncDec64() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testEncDec64())
}

func (suite *GoTestSuite) TestFirstClassFunction() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testFirstClassFunction())
}

func (suite *GoTestSuite) TestFunctionOrdering() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testFunctionOrdering())
}

func (suite *GoTestSuite) TestArgumentOrder() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testArgumentOrder())
}

func (suite *GoTestSuite) TestGenerics() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testGenerics())
}

func (suite *GoTestSuite) TestU64ToU32() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testU64ToU32())
}

func (suite *GoTestSuite) TestU32Len() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testU32Len())
}

func (suite *GoTestSuite) TestU32NewtypeLen() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testU32NewtypeLen())
}

func (suite *GoTestSuite) TestBasicInterface() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBasicInterface())
}

func (suite *GoTestSuite) TestAssignInterface() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAssignInterface())
}

func (suite *GoTestSuite) TestMultipleInterface() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testMultipleInterface())
}

func (suite *GoTestSuite) TestBinaryExprInterface() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBinaryExprInterface())
}

func (suite *GoTestSuite) TestIfStmtInterface() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testIfStmtInterface())
}

func (suite *GoTestSuite) TestsUseLocks() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testsUseLocks())
}

func (suite *GoTestSuite) TestStandardForLoop() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testStandardForLoop())
}

func (suite *GoTestSuite) TestForLoopWait() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testForLoopWait())
}

func (suite *GoTestSuite) TestBreakFromLoopWithContinue() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBreakFromLoopWithContinue())
}

func (suite *GoTestSuite) TestBreakFromLoopNoContinue() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBreakFromLoopNoContinue())
}

func (suite *GoTestSuite) TestBreakFromLoopNoContinueDouble() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBreakFromLoopNoContinueDouble())
}

func (suite *GoTestSuite) TestBreakFromLoopForOnly() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBreakFromLoopForOnly())
}

func (suite *GoTestSuite) TestBreakFromLoopAssignAndContinue() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBreakFromLoopAssignAndContinue())
}

func (suite *GoTestSuite) TestNestedLoops() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testNestedLoops())
}

func (suite *GoTestSuite) TestNestedGoStyleLoops() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testNestedGoStyleLoops())
}

func (suite *GoTestSuite) TestNestedGoStyleLoopsNoComparison() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testNestedGoStyleLoopsNoComparison())
}

func (suite *GoTestSuite) TestIterateMap() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testIterateMap())
}

func (suite *GoTestSuite) TestMapSize() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testMapSize())
}

func (suite *GoTestSuite) TestAssignTwo() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAssignTwo())
}

func (suite *GoTestSuite) TestAssignThree() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAssignThree())
}

func (suite *GoTestSuite) TestMultipleAssignToMap() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testMultipleAssignToMap())
}

func (suite *GoTestSuite) TestReturnTwo() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testReturnTwo())
}

func (suite *GoTestSuite) TestAnonymousBinding() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAnonymousBinding())
}

func (suite *GoTestSuite) TestReturnThree() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testReturnThree())
}

func (suite *GoTestSuite) TestReturnFour() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testReturnFour())
}

func (suite *GoTestSuite) TestCompareSliceToNil() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testCompareSliceToNil())
}

func (suite *GoTestSuite) TestComparePointerToNil() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testComparePointerToNil())
}

func (suite *GoTestSuite) TestCompareNilToNil() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testCompareNilToNil())
}

func (suite *GoTestSuite) TestComparePointerWrappedToNil() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testComparePointerWrappedToNil())
}

func (suite *GoTestSuite) TestComparePointerWrappedDefaultToNil() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testComparePointerWrappedDefaultToNil())
}

func (suite *GoTestSuite) TestReverseAssignOps64() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testReverseAssignOps64())
}

func (suite *GoTestSuite) TestReverseAssignOps32() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testReverseAssignOps32())
}

func (suite *GoTestSuite) TestAdd64Equals() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAdd64Equals())
}

func (suite *GoTestSuite) TestSub64Equals() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testSub64Equals())
}

func (suite *GoTestSuite) TestDivisionPrecedence() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testDivisionPrecedence())
}

func (suite *GoTestSuite) TestModPrecedence() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testModPrecedence())
}

func (suite *GoTestSuite) TestBitwiseOpsPrecedence() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBitwiseOpsPrecedence())
}

func (suite *GoTestSuite) TestArithmeticShifts() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testArithmeticShifts())
}

func (suite *GoTestSuite) TestBitAddAnd() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testBitAddAnd())
}

func (suite *GoTestSuite) TestManyParentheses() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testManyParentheses())
}

func (suite *GoTestSuite) TestOrCompareSimple() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testOrCompareSimple())
}

func (suite *GoTestSuite) TestOrCompare() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testOrCompare())
}

func (suite *GoTestSuite) TestAndCompare() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAndCompare())
}

func (suite *GoTestSuite) TestShiftMod() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testShiftMod())
}

func (suite *GoTestSuite) TestLinearize() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testLinearize())
}

func (suite *GoTestSuite) TestShortcircuitAndTF() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testShortcircuitAndTF())
}

func (suite *GoTestSuite) TestShortcircuitAndFT() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testShortcircuitAndFT())
}

func (suite *GoTestSuite) TestShortcircuitOrTF() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testShortcircuitOrTF())
}

func (suite *GoTestSuite) TestShortcircuitOrFT() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testShortcircuitOrFT())
}

func (suite *GoTestSuite) TestSliceOps() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testSliceOps())
}

func (suite *GoTestSuite) TestSliceCapacityOps() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testSliceCapacityOps())
}

func (suite *GoTestSuite) TestOverwriteArray() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testOverwriteArray())
}

func (suite *GoTestSuite) TestStringAppend() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testStringAppend())
}

func (suite *GoTestSuite) TestStringLength() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testStringLength())
}

func (suite *GoTestSuite) TestFooBarMutation() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testFooBarMutation())
}

func (suite *GoTestSuite) TestStructUpdates() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, failing_testStructUpdates())
}

func (suite *GoTestSuite) TestNestedStructUpdates() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testNestedStructUpdates())
}

func (suite *GoTestSuite) TestStructConstructions() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testStructConstructions())
}

func (suite *GoTestSuite) TestIncompleteStruct() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testIncompleteStruct())
}

func (suite *GoTestSuite) TestStoreInStructVar() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testStoreInStructVar())
}

func (suite *GoTestSuite) TestStoreInStructPointerVar() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testStoreInStructPointerVar())
}

func (suite *GoTestSuite) TestStoreComposite() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testStoreComposite())
}

func (suite *GoTestSuite) TestStoreSlice() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testStoreSlice())
}

func (suite *GoTestSuite) TestStructFieldFunc() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testStructFieldFunc())
}

func (suite *GoTestSuite) TestPointerAssignment() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testPointerAssignment())
}

func (suite *GoTestSuite) TestAddressOfLocal() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAddressOfLocal())
}

func (suite *GoTestSuite) TestAnonymousAssign() {
	d := disk.NewMemDisk(30)
	disk.Init(d)
	suite.Equal(true, testAnonymousAssign())
}

func TestSuite(t *testing.T) {
	suite.Run(t, new(GoTestSuite))
}
