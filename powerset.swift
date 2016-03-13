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

func powerset(numbers: [Int]) -> [Set<Int>] {
    
    func combine(head: Set<Int>, tail: ArraySlice<Set<Int>>) -> [Set<Int>] {
        if tail.isEmpty {
            return [head]
        }
        
        return tail.reduce([Set<Int>]()){(a: [Set<Int>], b: Set<Int>) -> [Set<Int>] in
            return a + [head.union(b)]
        }
        
    }
    
    func recurse(input: ArraySlice<Set<Int>>, accumulator: [Set<Int>]) -> [Set<Int>] {
        if input.count <= 1 {
            return accumulator
        }
        let x = combine(input.first!, tail: input.dropFirst(1))
        return recurse(x.dropFirst(0), accumulator: accumulator + x) + recurse(input.dropFirst(1), accumulator: [])
    }
    
    if numbers.isEmpty {
        return []
    }
    
    let set = numbers.map{ Set([$0]) }
    return recurse(set.dropFirst(0), accumulator: set)
}

func xorSum<T: CollectionType where T.Generator.Element == Int>(set:T) -> Int {
    if set.isEmpty {
        return 0
    } else if set.count == 1 {
        return set.first!
    }
    
    return set.reduce(0){ a, b in
        return a ^ b
    }
}

func readInt() -> Int {
    return Int(readLine()!)!
}

func readArray() -> [Int] {
    return readLine()!.componentsSeparatedByString(" ").flatMap{ Int($0) }
}

let testcases = readInt()

let modNumber = 100007

for _ in 0..<testcases {
    let _ = readInt()
    let numbers = readArray()
    let pset = powerset(numbers)
    let xorsum = pset.reduce(0){i, s in return i + xorSum(s) } % modNumber
    
    print(xorsum)
}
