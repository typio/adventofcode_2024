//
//  Day01.swift
//  aoc_2024
//
//  Created by TH on 11/30/24.
//

import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day01.txt")
    if var content: String = try? String(contentsOf: filepath, encoding: .ascii) {

        var cols: ([Int], [Int]) = ([], [])
        var sumDifference = 0
        let p1_time: ContinuousClock.Instant.Duration = clock.measure {
            _ = content.split(separator: "\n", omittingEmptySubsequences: true).map { row in
                let pair: [Int] = row.split(separator: "   ", omittingEmptySubsequences: true).map {
                    numberString in
                    Int(numberString)!
                }
                cols.0.append(pair[0])
                cols.1.append(pair[1])

            }
            cols.0.sort()
            cols.1.sort()

            for i in 0..<cols.0.count {
                sumDifference += abs(cols.0[i] - cols.1[i])
            }
        }
        print("Part 1: \(sumDifference), time: \(p1_time)")

        var sumOfMatches = 0
        let unique_col1 = Array(Set(cols.0))
        let p2_time: ContinuousClock.Instant.Duration = clock.measure {
            for i in 0..<unique_col1.count {
                let n1: Int = cols.0[i]

                var occurences: Int = 0
                for j in 0..<cols.1.count {
                    let n2: Int = cols.1[j]
                    if n1 == n2 {
                        occurences += 1
                    } else if n2 > n1 {
                        break
                    }
                }
                sumOfMatches += n1 * occurences
            }
        }
        print("Part 2: \(sumOfMatches), time: \(p2_time)")

    } else {
        print("Failed to read file")
    }
}

main()