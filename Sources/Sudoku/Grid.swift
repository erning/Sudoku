//
//
//

import Foundation

public struct Grid {
    /*
     The following table shows the index of all squares.
     0>   0  1  2 |  3  4  5 |  6  7  8
     1>   9 10 11 | 12 13 14 | 15 16 17
     2>  18 19 20 | 21 22 23 | 24 25 26
        ----------+----------+----------
     3>  27 28 29 | 30 31 32 | 33 34 35
     4>  36 37 38 | 39 40 41 | 42 43 44
     5>  45 46 47 | 48 49 50 | 51 52 53
        ----------+----------+----------
     6>  54 55 56 | 57 58 59 | 60 61 62
     7>  63 64 65 | 66 67 68 | 69 70 71
     8>  72 73 74 | 75 76 77 | 78 79 80
    */
    var raw = [UInt8](repeating: 0, count: 81)

    public subscript(i: Int) -> UInt8 {
        get {
            return self.raw[i]
        }
        set(newValue) {
            self.raw[i] = newValue
        }
    }
    
    var emptySquareCount: Int {
        // return self.raw.filter{$0 == 0}.count
        var count = 0
        for n in self.raw where n == 0 {
            count += 1
        }
        return count
    }
    
    var emptySquares: [Int] {
        var squares = [Int]()
        for i in 0..<81 where self.raw[i] == 0 {
            squares.append(i)
        }
        return squares
    }
}

extension Grid {
    public var isValid: Bool {
        get {
            var taken = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 3)
            for i in 0..<81 where self.raw[i] > 0 {
                let bit = Int(1) << (self.raw[i] - 1)
                for k in 0..<3 {
                    let j = Self.RCB[i][k]
                    if (taken[k][j] & bit) != 0 {
                        return false
                    }
                    taken[k][j] |= bit
                }
            }
            return true
        }
    }
    
    func isValid(_ i: Int, _ n: UInt8) -> Bool {
        var taken = 0
        for j in Self.RELATIVES[i] {
            if self.raw[j] > 0 {
                taken |= 1 << (self.raw[j] - 1)
            }
        }
        return (taken & (1 << (n-1))) == 0
    }

    func possibleNumbers(_ i: Int) -> [UInt8] {
        var taken = 0
        for j in Self.RELATIVES[i] {
            if self.raw[j] > 0 {
                taken |= 1 << (self.raw[j] - 1)
            }
        }
        var nums = [UInt8]()
        for n in 0..<9 {
            if (taken & (1 << n)) == 0 {
                nums.append(UInt8(n+1))
            }
        }
        return nums
    }
    
    static let RCB: [[Int]] = {
        var v = [[Int]](repeating: [0,0,0], count: 81)
        for i in 0..<81 {
            v[i][0] = i / 9
            v[i][1] = i % 9
            v[i][2] = i/27*3 + (i/3)%3
        }
        return v
    }()
    
    static let ROWS: [[Int]] = {
        var v = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        for i in 0..<9 {
            for j in 0..<9 {
                v[i][j] = i*9 + j
            }
        }
        return v
    }()
    
    static let COLS: [[Int]] = {
        var v = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        for i in 0..<9 {
            for j in 0..<9 {
                v[i][j] = i + j*9
            }
        }
        return v
    }()
    
    static let BOXES: [[Int]] = {
        var v = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        for i in 0..<9 {
            for j in 0..<9 {
                v[i][j] = j/3*9 + j%3 + i/3*27 + (i%3)*3
            }
        }
        return v
    }()
    
    static let RELATIVES: [[Int]] = {
        var v = [[Int]](repeating: [], count: 81)
        for i in 0..<81 {
            var m = Set<Int>()
            for j in Self.ROWS[Self.RCB[i][0]] {
                m.insert(j)
            }
            for j in COLS[Self.RCB[i][1]] {
                m.insert(j)
            }
            for j in BOXES[Self.RCB[i][2]] {
                m.insert(j)
            }
            v[i] = Array(m)
        }
        return v
    }()
}

extension Grid: CustomStringConvertible {
    public init(_ data: String) {
        var i = 0
        for c in data where i < 81 {
            if let c = c.asciiValue {
                if c >= 0x30 && c <= 0x39 {
                    self.raw[i] = c - 0x30
                    i += 1
                } else if c == 0x2e {
                    self.raw[i] = 0
                    i += 1
                }
            }
        }
    }
    
    public var description: String {
        get {
            var s = ""
            for i in 0..<81 {
                if i > 0 {
                    if i % 9 == 0 {
                        s += "\n"
                    } else if i % 3 == 0 {
                        s += " |"
                    }
                    if i % 27 == 0 {
                        s += "-------+-------+-------\n"
                    }
                }
                let c = self.raw[i]
                if c == 0 {
                    s += " ."
                } else {
                    s += " \(c)"
                }
            }
            return s
        }
    }
}
