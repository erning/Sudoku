//
//
//

import Foundation

public class Solver {
    public static func solve(_ grid: Grid) -> Grid? {
        var g = grid
        
        func solveInternal() -> Bool {
            let (i, pn) = self.findEmptySquare(g)
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
