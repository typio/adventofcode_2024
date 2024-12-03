import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day03.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var sum_of_products = 0
    let p1_time: ContinuousClock.Instant.Duration = clock.measure {
        let regex = try! Regex("mul\\(\\d+,\\d+\\)")

        let matches = content.matches(of: regex)

        for match in matches {
            let parts = String(match.0).components(separatedBy: ",").map {
                Int($0.filter("0123456789".contains))!
            }
            sum_of_products += parts[0] * parts[1]
        }
    }
    print("Part 1: \(sum_of_products), time: \(p1_time)")

    var sum_of_products2 = 0
    let p2_time: ContinuousClock.Instant.Duration = clock.measure {
        let regex = try! Regex("mul\\(\\d+,\\d+\\)|(do\\(\\))|(don't\\(\\))")

        let matches = content.matches(of: regex)

        var enabled = true
        for match in matches {
            let match = String(match.0)

            if match == "do()" {
                enabled = true
            } else if match == "don't()" {
                enabled = false
            } else {
                if enabled {
                    let parts = match.components(separatedBy: ",").map {
                        Int($0.filter("0123456789".contains))!
                    }
                    sum_of_products2 += parts[0] * parts[1]
                }
            }
        }
    }
    print("Part 2: \(sum_of_products2), time: \(p2_time)")
}

main()
