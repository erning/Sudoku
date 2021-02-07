// Sudoku

import Foundation

public struct Solution {
    public typealias Step = (position: Int, number: UInt8)

    public let origin: Grid
    public let steps: [Step]

    public var final: Grid {
        var grid = origin
        for step in steps {
            grid[step.position] = step.number
        }
        return grid
    }
}

public enum SolveResult {
    case success(Solution)
    case invalid
    case failure
}

public typealias SolvingCallback = (_ current: Grid, _ steps: [Solution.Step]) -> Bool

public protocol Solver {
    func solve(_: Grid) -> SolveResult
    func solve(_: Grid, callback: SolvingCallback) -> SolveResult
}

public class DefaultSolver: Solver {
    public init() {}

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

    public func solve(_ origin: Grid) -> SolveResult {
        solve(origin, callback: { _, _ in true })
    }

    public func solve(_ origin: Grid, callback: SolvingCallback) -> SolveResult {
        if !origin.isValid {
            return .invalid
        }

        var grid = origin
        var steps: [Solution.Step] = []

        func solveInternal() -> Bool {
            if callback(grid, steps) == false {
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

        return solveInternal()
            ? .success(Solution(origin: origin, steps: steps))
            : .failure
    }
}
