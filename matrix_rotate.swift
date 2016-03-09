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

struct Point {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    static let zero = Point(0, 0)
}

extension Point: Equatable { }

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

func +(lhs: Point, rhs: Point) -> Point {
    return Point(lhs.x + rhs.x, lhs.y + rhs.y)
}

struct Matrix {
    
    let columns: Int
    let rows: Int
    let members: [Int]
    
    var count: Int {
        return members.count
    }
    
    var isSquare: Bool {
        return columns == rows
    }
    
    private var circumference: Int {
        return 2 * (rows + columns) - 4
    }
    
    func rowAsString(row: Int) -> String {
        precondition(row < rows)
        let start = row * columns
        let range = start..<(start + columns)
        return members[range].map{ "\($0)" }.joinWithSeparator(" ")
    }
    
    /// Return the index point
    func indexOf(point: Point) -> Int {
        return point.y * columns + point.x
    }
    
    /// Rotate the 'rings' of a matrix in a counter-clockwise fashion
    func rotate(moves: Int) -> Matrix {
        if isSquare && moves % circumference == 0 {
            // Optimisation: if we're square and the number of moves
            // mod the count of our outer ring == 0, we're done!
            return self
        }
        
        // create a range that will allow us to step diagonally toward the centre
        let range = 0..<(min(columns, rows)/2)
        
        var rings: [[(Int,Int)]] = []
        for i in range {
            let offset = Point(i, i)
            let ring = self.ring(offset)
            let cursor = moves % ring.count
            if  cursor == 0 {
                rings.append(ring.map{ ($0, $0) })
            } else {
                let array = rotateRing(ring, num: cursor)
                rings.append(array)
            }
        }
        
        // flatten, sort then lookup the values
        let result = rings.flatMap{ $0 }
            .sort{ a, b in return a.0 < b.0 }
            .map{ (_, i) in return members[i] }
        
        return Matrix(columns: columns, rows: rows, members: result)
    }
    
    // Take suffix + prefix and zip them with the original indices so we can sort them later
    private func rotateRing(ring: [Int], num: Int) -> [(Int,Int)] {
        let a = ring.suffixFrom(num)
        let b = ring.prefixUpTo(num)
        return Array(zip(ring, a + b))
    }
    
    // Assemble an array of indices from a point starting at origin + offset
    // e.g (1,1) and working clockwise around the matrix through corners
    // 'b', 'd' and 'c' back to 'a'.
    private func ring(offset: Point = Point.zero) -> [Int] {
        let f: [Corners -> [Int]] = [a_to_b, b_to_d, d_to_c, c_to_a]
        let c = corners(offset)
        return f.flatMap{ $0(c) }.map{ $0 }
    }
    
    typealias Corners = (a: Point, b:Point, c: Point, d: Point)
    
    private func corners(offset: Point) -> Corners {
        return (offset,
            Point(columns - 1 - offset.x, offset.y),
            Point(offset.x, rows - 1 - offset.y),
            Point(columns - 1 - offset.x, rows - 1 - offset.y)
        )
    }
    
    /*
     *   |  0  |  1  |  2  |
     *   -------------------
     *   |  3  |  4  |  5  |
     *   -------------------
     *   |  6  |  7  |  8  |
     *
     *   Notes:  
     *           Point a = 0 or (0, 0). This is the origin or top left
     *           Point b = 2 or (2, 0). i.e top right
     *           Point c = 6 or (0, 2). i.e bottom left
     *           Point d = 8 or (2, 2). i.e bottom right
     *
     */
    
    // [0, 1]
    private func a_to_b(points: Corners) -> [Int] {
        return (points.a.x..<points.b.x).map{ points.a.y * columns + $0 }
    }
    
    // [2, 5]
    private func b_to_d(points: Corners) -> [Int] {
        return (points.b.y..<points.d.y).map{ $0 * columns + points.b.x }
    }
    
    // [8, 7]
    private func d_to_c(points: Corners) -> [Int] {
        return ((points.c.x + 1)...points.d.x).reverse().map{ points.c.y * columns + $0 }
    }
    
    // [6, 3]
    private func c_to_a(points: Corners) -> [Int] {
        return ((points.a.y + 1)...points.c.y).reverse().map{ $0 * columns + points.a.x }
    }
    
}
