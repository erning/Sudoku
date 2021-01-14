//
//
//

import Foundation

public class Solver {
    private class State {
        let g: Grid
        var i = -1
        var pn = [UInt8]()
        
        init(_ grid: Grid) {
            self.g = grid
        }
    }
    
    private var states = [State]()
    
    public init(_ grid: Grid) {
        states.append(State(grid))
    }
    
    public func next() -> Grid?{
        while true {
            guard let state = states.last else {
                return nil
            }
            if state.i == -1 {
                let (i, pn) = Self.findEmptySquare(state.g)
                if i < 0 {
                    return nil
                }
                state.i = i
                state.pn = pn
            }
            
            guard let n = state.pn.popLast() else {
                states.removeLast()
                continue
            }
            var grid = state.g
            grid[state.i] = n

            states.append(State(grid))
            return grid
        }
    }
    
    public static func solve(_ grid: Grid) -> Grid? {
        var g = grid
        
        func solveInternal() -> Bool {
            let (i, pn) = Self.findEmptySquare(g)
            if i < 0 {
                return true
            }

            for n in pn {
                g[i] = n
                if solveInternal() == true {
                    return true
                }
            }
            g[i] = 0
            return false
        }
        
        return solveInternal() ? g : nil
    }
    
    // (found square index, possible numbers)
    static func findEmptySquare(_ grid: Grid) -> (Int, [UInt8]) {
        var mi = -1
        var mpn = [UInt8]()
        for i in 0..<81 where grid[i] == 0 {
            let pn = grid.possibleNumbers(i)
            if pn.isEmpty {
                // there's empty square, but no possible number for it
                return (i, [])
            }
            if pn.count == 1 {
                // there's only one possible number for the square, use it
                return (i, pn)
            }
            if mi == -1 || pn.count < mpn.count {
                mi = i
                mpn = pn
            }
        }
        return (mi, mpn)
    }
}

extension Solver: Sequence {
    public func makeIterator() -> SolverIterator {
        return SolverIterator(self)
    }
}

public class SolverIterator: IteratorProtocol {
    let solver: Solver
    
    init(_ solver: Solver) {
        self.solver = solver
    }
    
    public func next() -> Grid? {
        return self.solver.next()
    }
}
