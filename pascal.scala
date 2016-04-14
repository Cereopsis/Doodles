object Pascal extends App {

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
    
    def diagonal(n: Int, k: Int): BigInt = {
        if (n == 1 || k == 1) n
        else {
            val numer = (k + 1) until (k + n)
            val denom = 1 until n
            numer.zip(denom).foldLeft(BigInt(1))((a, b) => (a * b._1)/b._2) % modulus
        } 
    }

}
