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

struct BigInteger {
    
    let digits: [Int]
    
    init(_ number: Int) {
        digits = BigInteger.digits(number)
    }
    
    private init(digits: [Int]) {
        self.digits = digits
    }
    
    func add(other: BigInteger) -> BigInteger {
        func padding(delta: Int) -> [Int] {
            if delta <= 0 {
                return []
            }
            return Array(count: delta, repeatedValue: 0)
        }
        
        // pad to equal length by appending zeros, if needed
        let lhs = digits + padding(digits.count.distanceTo(other.digits.count))
        let rhs = other.digits + padding(other.digits.count.distanceTo(digits.count))
        
        let array = Array(SumGenerator(lhs: lhs, rhs: rhs))
        return BigInteger(digits: array)
    }
    
    func toString() -> String {
        return digits.reverse().map{ String.init($0) }.joinWithSeparator("")
    }
    
    internal static func digits(i: Int) -> [Int] {
        func _digits(num: Int, acc: [Int]) -> [Int] {
            if num == 0 {
                return acc
            }
            return _digits(num/10, acc: acc + [num % 10])
        }
        return _digits(i, acc: [])
    }
}

func +(lhs: BigInteger, rhs: BigInteger) -> BigInteger {
    return lhs.add(rhs)
}

struct SumGenerator: GeneratorType, SequenceType {
    
    typealias Element = Int
    typealias Generator = SumGenerator
    
    private var remainder: Int = 0
    private var cursor: Int = 0
    
    let lhs: [Int]
    let rhs: [Int]
    
    init(lhs: [Int], rhs: [Int]) {
        self.lhs = lhs
        self.rhs = rhs
    }

    
    func generate() -> SumGenerator {
        return self
    }
    
    mutating func next() -> Element? {
        if cursor == lhs.endIndex {
            defer {
                remainder = 0
            }
            return remainder == 0 ? nil : remainder
        }
        
        defer {
            cursor += 1
        }
        
        let sum = lhs[cursor] + rhs[cursor] + remainder
        remainder = sum / 10
        return sum % 10
    }
}

func sumInput(line: String) -> String {
    let nums = line.componentsSeparatedByString(" ").flatMap{ Int($0) }.map{ BigInteger($0) }
    let sum = nums.reduce(BigInteger(0), combine: +)
    return sum.toString()
} 


// Example usage: type space-separated integers into STDIN
// print(sumInput(readLine()!))

