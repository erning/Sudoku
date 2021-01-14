import XCTest
@testable import Sudoku

final class SudokuTests: XCTestCase {
    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//         XCTAssertEqual(Sudoku().text, "Hello, World!")
    }
    
    func testSolver() throws {
        let grid = Grid(
            """
            7 . . . . 1 5 . 9
            2 . . 4 . . . 8 .
            . . . . . 8 . 4 7
            . . . 5 . . 8 . 1
            . 6 . 2 8 . . 7 4
            . . . . . . . 3 .
            . . . 9 . 2 . . .
            4 . 5 7 . 6 . . .
            . . . . 5 . . . 2
            """
        )
        print(grid)
        print()
        if let g = Solver.solve(grid) {
            print(g)
        } else {
            print("Fail")
        }
    }
    
    func testStepByStep() {
        let grid = Grid(
            """
            7 . . . . 1 5 . 9
            2 . . 4 . . . 8 .
            . . . . . 8 . 4 7
            . . . 5 . . 8 . 1
            . 6 . 2 8 . . 7 4
            . . . . . . . 3 .
            . . . 9 . 2 . . .
            4 . 5 7 . 6 . . .
            . . . . 5 . . . 2
            """
        )
        print(grid)
        let solver = Solver(grid)
        for g in solver {
            print()
            print(g)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
