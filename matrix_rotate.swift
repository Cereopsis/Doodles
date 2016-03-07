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
    
    func negate() -> Point {
        return Point(-x, -y)
    }
    
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
    
    typealias Corners = (a: Point, b:Point, c: Point, d: Point)
    
    private func corners(offset: Point) -> Corners {
        return (offset,
                Point(columns - 1 - offset.x, offset.y),
                Point(offset.x, rows - 1 - offset.y),
                Point(columns - 1 - offset.x, rows - 1 - offset.y)
        )
    }
    
    func indexOf(point: Point) -> Int {
        return point.y * columns + point.x
    }
    
    func rotate(moves: Int) -> [Int] {
//        if isSquare && count % moves == 0 {
//            return self
//        }
        
        let range = 0..<(min(columns, rows)/2)
        
        var rings: [[Int]] = []
        for i in range {
            let offset = Point(i, i)
            let ring = self.ring(offset)
            let cursor = ring.count % moves
            if  cursor == 0 {
                rings.append(ring)
            } else {
                let array = rotateRing(ring, num: cursor)
                rings.append(array)
            }
        }
        
        return rings.flatMap({ $0 })
    }
    
    private func rotateRing(ring: [Int], num: Int) -> [Int] {
        let a = ring[num..<ring.endIndex]
        let b = ring[(ring.startIndex)..<num]
        return Array(a + b)
    }
    
    
    private func ring(offset: Point = Point.zero) -> [Int] {
        let f: [Corners -> [Int]] = [a_to_b, b_to_d, d_to_c, c_to_a]
        let c = corners(offset)
        return f.flatMap{ $0(c) }
    }
    
    private func a_to_b(points: Corners) -> [Int] {
        return (points.a.x..<points.b.x).map{ points.a.y * columns + $0 }
    }
    
    private func b_to_d(points: Corners) -> [Int] {
        return (points.b.y..<points.d.y).map{ $0 * columns + points.b.x }
    }
    
    private func d_to_c(points: Corners) -> [Int] {
        return ((points.c.x + 1)...points.d.x).reverse().map{ points.c.y * columns + $0 }
    }
    
    private func c_to_a(points: Corners) -> [Int] {
        return ((points.a.y + 1)...points.c.y).reverse().map{ $0 * columns + points.a.x }
    }
    
}
