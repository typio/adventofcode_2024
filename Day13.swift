// Total time: 0.008643583 seconds

import Foundation

// copied this
func solve(x1: Int, x2: Int, y1: Int, y2: Int, z1: Int, z2: Int) -> Int {
    let b = (z2 * x1 - z1 * x2) / (y2 * x1 - y1 * x2)
    let a = (z1 - b * y1) / x1
    if (x1 * a + y1 * b) != z1 || x2 * a + y2 * b != z2 {
        return 0
    }
    return a * 3 + b
}

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day13.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var answer = 0
    var answer2 = 0
    let time = clock.measure {
        let regex = try! Regex("(\\d+)+")

        let matches = content.matches(of: regex)
        for match_i in 0..<matches.count / 6 {
            let x1 = Int(matches[match_i * 6].0)!
            let x2 = Int(matches[match_i * 6 + 1].0)!
            let y1 = Int(matches[match_i * 6 + 2].0)!
            let y2 = Int(matches[match_i * 6 + 3].0)!
            let z1 = Int(matches[match_i * 6 + 4].0)!
            let z2 = Int(matches[match_i * 6 + 5].0)!
            print(x1, x2, y1, y2, z1, z2)

            answer += solve(x1: x1, x2: x2, y1: y1, y2: y2, z1: z1, z2: z2)
            answer2 += solve(
                x1: x1, x2: x2, y1: y1, y2: y2, z1: z1 + 10_000_000_000_000,
                z2: z2 + 10_000_000_000_000)
        }
    }

    print("Part 1: \(answer), Part 2: \(answer2), time: \(time)")
}

main()
