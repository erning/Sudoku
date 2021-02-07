// Sudoku

@testable import Sudoku
import XCTest

final class SudokuTests: XCTestCase {
    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//         XCTAssertEqual(Sudoku().text, "Hello, World!")
    }

    func testRelationship() throws {
        XCTAssertEqual(
            Grid.relatedPositions(at: 0),
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 18, 19, 20, 27, 36, 45, 54, 63, 72]
        )
        XCTAssertEqual(
            Grid.relatedPositions(at: 31),
            [4, 13, 22, 27, 28, 29, 30, 32, 33, 34, 35, 39, 40, 41, 48, 49, 50, 58, 67, 76]
        )
        XCTAssertEqual(
            Grid.relatedPositions(at: 80),
            [8, 17, 26, 35, 44, 53, 60, 61, 62, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79]
        )
    }

    func testIsCollided() throws {
        let grid = Grid.example
        XCTAssertFalse(grid.isCollided(at: 0, with: 7))
        XCTAssertTrue(grid.isCollided(at: 1, with: 7))
        XCTAssertFalse(grid.isCollided(at: 1, with: 8))
    }

    func testCollidedCells() throws {
        var grid = Grid.example
        grid[2] = 7
        XCTAssertEqual(grid.collidedCells(at: 2, with: 5), [6, 65])
        XCTAssertEqual(grid.collidedCells(at: 0, with: 7), [2])
        XCTAssertEqual(grid.collidedCells, [0, 2])
    }

    func testPossibleNumbers() throws {
        let grid = Grid.example
        XCTAssertEqual(grid.possibleNumbers(at: 0), [3, 6, 7, 8])
        XCTAssertEqual(grid.possibleNumbers(at: 1), [3, 4, 8])
    }

    func testSolution() throws {
        let grid = Grid.example

        var count = 0
        let progress: Solver.ProgressCallback = { _, _ in
            count += 1
            return true
        }

        let result = DefaultSolver().solve(grid, progress: progress)
        switch result {
        case .success(let solution):
            XCTAssertEqual(solution.steps.count, grid.emptyCells.count)
            XCTAssert(true)
            // print(count)
        default:
            XCTAssert(false)
        }
    }

    func testNoSolution() throws {
        var grid = Grid.example
        grid[1] = 8
        let result = DefaultSolver().solve(grid)
        switch result {
        case .failure:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testSolved() throws {
        let grid = Grid([
            0, 0, 0, 4, 0, 6, 0, 0, 0,
            7, 0, 0, 2, 0, 0, 0, 9, 0,
            0, 0, 0, 0, 5, 3, 0, 0, 4,
            0, 1, 3, 0, 0, 0, 0, 4, 9,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 4, 5, 0, 0, 0, 0, 2,
            3, 7, 0, 0, 6, 0, 0, 1, 0,
            5, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 2, 0, 0, 0, 0, 7, 0, 0,
        ])
        let expected = Grid([
            8, 3, 2, 4, 9, 6, 1, 5, 7,
            7, 4, 5, 2, 1, 8, 3, 9, 6,
            1, 9, 6, 7, 5, 3, 2, 8, 4,
            6, 1, 3, 8, 2, 7, 5, 4, 9,
            2, 5, 7, 6, 4, 9, 8, 3, 1,
            9, 8, 4, 5, 3, 1, 6, 7, 2,
            3, 7, 8, 9, 6, 2, 4, 1, 5,
            5, 6, 1, 3, 7, 4, 9, 2, 8,
            4, 2, 9, 1, 8, 5, 7, 6, 3,
        ])

        if case let .success(solution) = DefaultSolver().solve(grid) {
            XCTAssertEqual(solution.final, expected)
            return
        }
        XCTAssert(false)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
