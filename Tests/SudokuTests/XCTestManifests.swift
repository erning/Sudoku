// Sudoku

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(SudokuTests.allTests),
    ]
}
#endif
