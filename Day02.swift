//
//  Day02.swift
//  aoc_2024
//
//  Created by TH on 12/1/24.
//

import Foundation

func levelsAreSafe(levels: [Int]) -> Bool {
    var direction = 0
    var lastLevel = 0
    var isSafe = true
    for (i, level) in levels.enumerated() {
        if i != 0 {
            if i == 1 {
                if lastLevel < level {
                    direction = 1
                } else if lastLevel > level {
                    direction = -1
                } else {
                    isSafe = false
                    break
                }
            }

            if abs(lastLevel - level) > 3 || lastLevel == level {
                isSafe = false
                break
            }

            if direction == 1 && lastLevel > level {
                isSafe = false
                break
            }

            if direction == -1 && lastLevel < level {
                isSafe = false
                break
            }
        }
        lastLevel = level
    }
    return isSafe
}

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day02.txt")
    if let content: String = try? String(contentsOf: filepath, encoding: .ascii) {

        let array_of_levels = content.components(separatedBy: .newlines).map { row in
            row.components(separatedBy: .whitespaces).map { Int($0)! }
        }

        var safeReportCount = 0
        let p1_time: ContinuousClock.Instant.Duration = clock.measure {
            for levels in array_of_levels {
                if levelsAreSafe(levels: levels) {
                    safeReportCount += 1
                }
            }
        }
        print("Part 1: \(safeReportCount), time: \(p1_time)")

        var safeReportCount2 = 0
        let p2_time: ContinuousClock.Instant.Duration = clock.measure {
            for levels in array_of_levels {
                if levelsAreSafe(levels: levels) {
                    safeReportCount2 += 1
                } else {
                    for levelI in 0..<levels.count {
                        var levelsCopy = levels
                        levelsCopy.remove(at: levelI)
                        if levelsAreSafe(levels: levelsCopy) {
                            safeReportCount2 += 1
                            break
                        }
                    }
                }
            }
        }
        print("Part 2: \(safeReportCount2), time: \(p2_time)")

    } else {
        print("Failed to read file")
    }
}

main()
