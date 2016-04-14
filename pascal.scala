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
object Pascal extends App {

    // n choose r
    def ncr(r: Int, c: Int): BigInt = {
        require(c <= r)
        c match {
            case 0 => 1
            case 1 => r
            case _ => 
                (1 to r).reverse
                        .zip(1 to c)
                        .foldLeft(BigInt(1))((a, b) => (a * b._1)/b._2 )
        }
    }
    
    // calculate diagonal of pascal's triangle
    def diagonal(n: Int, k: Int): BigInt = {
        if (n == 1 || k == 1) n
        else {
            val numer = (k + 1) until (k + n)
            val denom = 1 until n
            numer.zip(denom).foldLeft(BigInt(1))((a, b) => (a * b._1)/b._2)
        } 
    }

}
