/*
The MIT License (MIT)

Copyright (c) 2015 Cereopsis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

struct Point<T: SignedIntegerType> {
    var x: T
    var y: T
    init(_ x: T, _ y: T) {
        self.x = x
        self.y = y
    }
}

extension Point: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Point(\(x), \(y))"
    }
}

func +<T>(lhs: Point<T>, rhs: Point<T>) -> Point<T> {
    return Point(lhs.x + rhs.x, lhs.y + rhs.y)
}

func -<T>(lhs: Point<T>, rhs: Point<T>) -> Point<T> {
    return Point(lhs.x - rhs.x, lhs.y - rhs.y)
}

func *<T>(lhs: Point<T>, rhs: Point<T>) -> Point<T> {
    return Point(lhs.x * rhs.x, lhs.y * rhs.y)
}


struct Matrix {
    
    static let origin: Point<Int> = Point(x: 0, y: 0)
    
    let columns: Int
    let rows: Int
    let members: [Int]
    
    init(columns: Int, rows: Int, members: [Int]) {
        precondition(members.count == columns * rows)
        self.columns = columns
        self.rows = rows
        self.members = members
    }
    
    var topLeft: Point<Int> {
        return Matrix.origin
    }
    
    var topRight: Point<Int> {
        return Point(x: columns - 1, y: 0)
    }
    
    var bottomLeft: Point<Int> {
        return Point(x: 0, y: rows - 1)
    }
    
    var bottomRight: Point<Int> {
        return Point(x: columns - 1, y: rows - 1)
    }
    
    func valueAt(point: Point<Int>) -> Int? {
        return valueAt(point.x, y: point.y)
    }
    
    private func valueAt(x: Int, y: Int) -> Int? {
        let loc = locationOf(x, y: y)
        if loc < members.endIndex {
            return members[loc]
        }
        return nil
    }
}
