// Sudoku

import Foundation

public struct Solution {
    public let origin: Grid
    public let steps: [(position: Int, number: UInt8)]

    public var solved: Grid {
        var grid = origin
        for (position, number) in steps {
            grid[position] = number
        }
        return grid
    }
}

public protocol Solver {
    func solve(_: Grid) -> Solution?
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
        if !origin.isValid {
            return nil
        }

        var grid = origin
        var steps: [(Int, UInt8)] = []

        func solveInternal() -> Bool {
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
