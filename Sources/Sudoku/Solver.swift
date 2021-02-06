// Sudoku

import Foundation

public struct Solution {
    public typealias Step = (position: Int, number: UInt8)

    public let origin: Grid
    public let steps: [Step]

    public var solved: Grid {
        var grid = origin
        for (position, number) in steps {
            grid[position] = number
        }
        return grid
    }
}

public protocol Solver {
    typealias ProgressCallback = (Grid, [Solution.Step]) -> Bool

    func solve(_: Grid) -> Solution?
    func solve(_: Grid, progress: ProgressCallback) -> Solution?
}

public class DefaultSolver: Solver {
    func leastPossibleNumbers(_ grid: Grid) -> (Int, [UInt8])? {
        var rv: (position: Int, numbers: [UInt8])?
        for position in grid.emptyCells {
            let numbers = grid.possibleNumbers(at: position)
            if numbers.isEmpty {
                return nil
            }
            if numbers.count == 1 {
                return (position, numbers)
            }
            if let least = rv {
                if numbers.count < least.numbers.count {
                    rv = (position, numbers)
                }
            } else {
                rv = (position, numbers)
            }
        }
        return rv
    }

    public func solve(_ origin: Grid) -> Solution? {
        solve(origin, progress: { _, _ in true })
    }

    public func solve(_ origin: Grid, progress: Solver.ProgressCallback) -> Solution? {
        if !origin.isValid {
            return nil
        }

        var grid = origin
        var steps: [Solution.Step] = []

        func solveInternal() -> Bool {
            if progress(grid, steps) == false {
                return false
            }
            if grid.emptyCells.isEmpty {
                return true
            }
            guard let (position, numbers) = leastPossibleNumbers(grid) else {
                return false
            }
            for number in numbers {
                steps.append((position, number))
                grid[position] = number
                if solveInternal() {
                    return true
                }
                steps.removeLast()
                grid[position] = 0
            }
            return false
        }

        return solveInternal() ? Solution(origin: origin, steps: steps) : nil
    }
}
