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

}
