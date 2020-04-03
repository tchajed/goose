package semantics

func failing_testCompareSliceToNil() bool {
	s := make([]byte, 0)
	return s != nil
}

func testComparePointerToNil() bool {
	s := new(uint64)
	return s != nil
}

func testCompareNilToNil() bool {
	s := new(*uint64)
	return *s == nil
}