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
#if os(OSX) || os(iOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

func readData() -> String? {
    let stdin = NSFileHandle.fileHandleWithStandardInput()
    let indata = stdin.readDataToEndOfFile()
    return String(data: indata, encoding: NSUTF8StringEncoding)
}

func makeScanner(string: String) -> NSScanner {
    let scanner = NSScanner(string: string)
    scanner.charactersToBeSkipped = NSCharacterSet.whitespaceAndNewlineCharacterSet()
    return scanner
}

func readCells(scanner: NSScanner, lines: Int) -> (Int, Int) {
    func scanNumber(num: Int) -> Int {
		var i = 0
        scanner.scanInteger(&i)
        return min(i, num)
    }
	
    var a: Int = Int.max
	var b: Int = Int.max
    
    for _ in 0..<lines {
        a = scanNumber(a)
        b = scanNumber(b)
    }
    
    return (a, b)
}


if let s = readData() {
    let scanner = makeScanner(s)
    var lines = 0
    scanner.scanInteger(&lines)
    let (a, b) = readCells(scanner, lines: lines)
    let answer = a * b
    print(answer)
}
