
/// Sum a range of Ints from 1..<n e.g to get the combination of pairs
func sum(n: Int) -> Int {
    let result = n/2 * (n-1)
    return result + (n % 2 * n/2)
}
