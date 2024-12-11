// Total time: 0.055 seconds

import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day11.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var answer = 0
    var answer2 = 0
    let time = clock.measure {
        var stones: [Double: Int] = [:]
        content.components(separatedBy: .whitespaces).forEach { stones[Double($0)!] = 1 }

        var temp_stones = stones
        for _ in 0..<25 {
            temp_stones = step(stones: temp_stones)
            let sum = temp_stones.reduce(0) { acc, curr in
                acc + curr.value
            }
            answer = sum
        }

        for _ in 0..<(50) {
            temp_stones = step(stones: temp_stones)
            let sum = temp_stones.reduce(0) { acc, curr in
                acc + curr.value
            }
            answer2 = sum
        }
    }

    print("Part 1: \(answer), Part 2: \(answer2), time: \(time)")
}

func step(stones: [Double: Int]) -> [Double: Int] {
    var new_stones: [Double: Int] = [:]
    for (stone, count) in stones {
        let is_even =
            (log10(stone) + 1).rounded(.down).truncatingRemainder(dividingBy: 2) == 0

        if stone == 0 {
            new_stones[1] = (new_stones[1] ?? 0) + count
        } else if is_even {
            let digits = (log10(stone) + 1).rounded(.down)
            let divisor = pow(10, digits / 2)

            let lhs = (stone / divisor).rounded(.down)
            let rhs = stone.truncatingRemainder(dividingBy: divisor)

            new_stones[lhs] = (new_stones[lhs] ?? 0) + count
            new_stones[rhs] = (new_stones[rhs] ?? 0) + count

        } else {
            let p = stone * 2024
            new_stones[p] = (new_stones[p] ?? 0) + count
        }
    }
    return new_stones
}

main()
