// Total time: 24.905 seconds!

import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day07.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var answer = 0
    var answer2 = 0
    var equations: [Int: [Int]] = [:]
    let time = clock.measure {
        for line in content.components(separatedBy: .newlines) {
            let parts = line.components(separatedBy: ":")

            equations[Int(parts[0])!] = parts[1].components(separatedBy: .whitespaces).filter {
                $0.count > 0
            }.map {
                Int($0)!
            }
        }

        for (result, values) in equations {

            for i in 0..<Int(pow(2, Double(values.count - 1))) {
                var res = values.first!

                for n_i in 1..<values.count {
                    if (i >> n_i) & 1 == 1 {
                        res += values[n_i]
                    } else {
                        res *= values[n_i]
                    }
                }

                if res == result {
                    answer += result
                    equations[result] = nil
                    break
                }
            }
        }

        var powers_of_three: [Int: Int] = [:]
        for n in 0...20 {
            powers_of_three[n] = Int(pow(3, Double(n)))
        }

        for (result, values) in equations {
            for i in 0..<powers_of_three[values.count - 1]! {
                var res = values.first!
                var n = 1
                for n_i in 1..<values.count {
                    let trit = (i / n) % 3

                    if trit == 0 {
                        res += values[n_i]
                    } else if trit == 1 {
                        res *= values[n_i]
                    } else {
                        res = Int(String(res) + String(values[n_i]))!
                    }

                    if res > result {
                        break
                    }

                    n *= 3
                }

                if res == result {
                    answer2 += result
                    break
                }
            }
        }

    }
    print("Part 1: \(answer), Part 2: \(answer + answer2), time: \(time)")
}

main()
