// Enter your code here
import Foundation

func powerset(nums: [Int]) -> [Set<Int>] {
    var result: [Set<Int>] = []
    for i in nums.startIndex..<nums.endIndex {
        for j in (i..<nums.endIndex).reverse() {
            if  i + 1 > j {
                result.append(Set(nums[i...i]))
                continue
            }
            for k in (i+1)...j {
                let set = nums[i...i] + nums[k...j]
                result.append(Set(set))
            }
        }
    }

    return result
}

func xorSum(set: Set<Int>) -> Int {
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
