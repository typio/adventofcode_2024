import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day01.txt")
    if var content: String = try? String(contentsOf: filepath, encoding: .ascii) {

        var cols: ([Int], [Int]) = ([], [])
        var sumDifference = 0
        let p1_time: ContinuousClock.Instant.Duration = clock.measure {
            _ = content.components(separatedBy: .newlines).map { row in
                let pair: [Int] = row.split(separator: "   ", omittingEmptySubsequences: true).map {
                    numberString in
                    Int(numberString)!
                }
                if pair.count == 2 {
                    cols.0.append(pair[0])
                    cols.1.append(pair[1])
                }
            }
            cols.0.sort()
            cols.1.sort()

            for i in 0..<cols.0.count {
                sumDifference += abs(cols.0[i] - cols.1[i])
            }
        }
        print("Part 1: \(sumDifference), time: \(p1_time)")

        var sumOfMatches = 0

        var unique_col1: [Int] = []
        for n in cols.0 {
            if unique_col1.last != n {
                unique_col1.append(contentsOf: [n])
            }
        }

        let p2_time: ContinuousClock.Instant.Duration = clock.measure {
            var freq: [Int: Int] = [:]
            for n in cols.1 {
                freq[n, default: 0] += 1
            }

            for n in unique_col1 {
                if let count = freq[n] {
                    sumOfMatches += n * count
                }
            }
        }
        print("Part 2: \(sumOfMatches), time: \(p2_time)")

    } else {
        print("Failed to read file")
    }
}

main()
