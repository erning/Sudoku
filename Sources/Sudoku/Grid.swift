// Sudoku

import Foundation

/*
  The following table shows the position of all cells.
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

public struct Grid {
    private var raw: [UInt8]
}

public extension Grid {
    init() {
        raw = [UInt8](repeating: 0, count: 81)
    }

    init(_ bytes: [UInt8]) {
        self.init()
        for i in 0 ..< bytes.count where i < raw.count {
            let number = bytes[i]
            raw[i] = number
        }
    }

    subscript(position: Int) -> UInt8 {
        get {
            raw[position]
        }
        set {
            raw[position] = newValue
        }
    }

    var numbers: [UInt8] { raw }

    var occupiedCells: [Int] {
        raw.indices.filter { raw[$0] > 0 }
    }

    var emptyCells: [Int] {
        raw.indices.filter { raw[$0] <= 0 }
    }

    func isCollided(at position: Int, with number: UInt8) -> Bool {
        if number == 0 {
            return false
        }
        for i in Self.relatedPositions(at: position) where raw[i] == number {
            return true
        }
        return false
    }

    func isCollided(at position: Int) -> Bool {
        isCollided(at: position, with: raw[position])
    }

    var collidedCells: [Int] {
        occupiedCells.filter { isCollided(at: $0, with: raw[$0]) }
    }

    func collidedCells(at position: Int, with number: UInt8) -> [Int] {
        Self.relatedPositions(at: position).filter { raw[$0] == number }
    }

    func collidedCells(at position: Int) -> [Int] {
        collidedCells(at: position, with: raw[position])
    }

    var isValid: Bool {
        for (position, number) in raw.enumerated() {
            if !Self.isValid(number: number) {
                return false
            }
            if isCollided(at: position, with: number) {
                return false
            }
        }
        return true
    }

    var isSolved: Bool {
        emptyCells.isEmpty && isValid
    }

    func possibleNumbers(at position: Int) -> [UInt8] {
        var usedNumbers: Set<UInt8> = []
        for i in Self.relatedPositions(at: position) where raw[i] > 0 {
            usedNumbers.insert(raw[i])
        }
        let possibleNumbers = Set<UInt8>(1 ... 9).subtracting(usedNumbers)
        return Array(possibleNumbers).sorted()
    }
}

public extension Grid {
    static func isValid(number: UInt8) -> Bool {
        number >= 0 && number <= 9
    }

    static func isValid(position: Int) -> Bool {
        position >= 0 && position < 81
    }

    static func relatedPositions(at position: Int) -> [Int] {
        positionRelationships[position]
    }
}

extension Grid {
    static let positionRelationships: [[Int]] = {
        var relationships: [[Int]] = []
        for position in 0 ..< 81 {
            var relationship: Set<Int> = []
            let row = position / 9
            let column = position % 9
            let block = position / 27 * 3 + (position / 3) % 3
            for i in 0 ..< 9 {
                relationship.insert(row * 9 + i)
                relationship.insert(i * 9 + column)
                relationship.insert(i / 3 * 9 + i % 3 + block / 3 * 27 + (block % 3) * 3)
            }
            relationship.remove(position)
            relationships.append(Array(relationship).sorted())
        }
        return relationships
    }()
}

extension Grid: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.raw == rhs.raw
    }
}

extension Grid: CustomStringConvertible {
    public var description: String {
        let empty = " ."
        var board = raw[0] == 0 ? empty : " \(raw[0])"
        for position in 1 ..< 81 {
            if position % 9 == 0 {
                board += "\n"
            } else if position % 3 == 0 {
                board += " |"
            }
            if position % 27 == 0 {
                board += "-------+-------+-------\n"
            }
            board += raw[position] == 0 ? " ." : " \(raw[position])"
        }
        return board
    }
}

public extension Grid {
    init(_ string: String) {
        self.init()
        var i = 0
        for char in string where i < raw.count {
            switch char.asciiValue {
            case let ascii? where ascii >= 0x30 && ascii <= 0x39:
                raw[i] = ascii - 0x30
                i += 1
            case let ascii? where ascii == 0x2E:
                raw[i] = 0
                i += 1
            case .some, .none:
                continue
            }
        }
    }

    static let example = Grid(
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
}
