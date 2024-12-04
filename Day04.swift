import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day04.txt")
    guard var contentString: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var content: [String.UTF8View.Element] = []
    var line_length: Int = 0
    var line_count: Int = 0
    var x: UInt8 = 0
    var m: UInt8 = 0
    var a: UInt8 = 0
    var s: UInt8 = 0

    let setup_time: ContinuousClock.Instant.Duration = clock.measure {
        content = Array(contentString.lowercased().utf8)

        line_length =
            contentString.distance(
                from: contentString.startIndex, to: contentString.firstIndex(of: "\n")!) + 1

        line_count = contentString.components(separatedBy: "\n").count

        x = Character("x").asciiValue!
        m = Character("m").asciiValue!
        a = Character("a").asciiValue!
        s = Character("s").asciiValue!
    }

    print("Setup time: \(setup_time)")

    var answer = 0
    let p1_time: ContinuousClock.Instant.Duration = clock.measure {
        for (i, c) in content.enumerated() {
            if c == x {
                // search right
                if line_length - i % line_length > 4 && content[i + 1] == m && content[i + 2] == a
                    && content[i + 3] == s
                {
                    answer += 1
                }

                // search left
                if i % line_length >= 3 && content[i - 1] == m && content[i - 2] == a
                    && content[i - 3] == s
                {
                    answer += 1
                }

                // search down
                if i + (line_length * 3) < content.count && content[i + line_length] == m
                    && content[i + (line_length * 2)] == a && content[i + (line_length * 3)] == s
                {
                    answer += 1
                }

                // search up
                if i >= line_length * 3 && content[i - line_length] == m
                    && content[i - (line_length * 2)] == a && content[i - (line_length * 3)] == s
                {
                    answer += 1
                }

                // search down right
                if line_length - i % line_length > 4 && i + (line_length * 3) < content.count
                    && content[i + line_length + 1] == m && content[i + (line_length * 2) + 2] == a
                    && content[i + (line_length * 3) + 3] == s
                {
                    answer += 1
                }

                // search down left
                if i % line_length >= 3 && i + (line_length * 3) < content.count
                    && content[i + line_length - 1] == m && content[i + (line_length * 2) - 2] == a
                    && content[i + (line_length * 3) - 3] == s
                {
                    answer += 1
                }

                // search up right
                if line_length - i % line_length > 4 && i >= line_length * 3
                    && content[i - line_length + 1] == m && content[i - (line_length * 2) + 2] == a
                    && content[i - (line_length * 3) + 3] == s
                {
                    answer += 1
                }

                // search up left
                if i % line_length >= 3 && i >= line_length * 3 && content[i - line_length - 1] == m
                    && content[i - (line_length * 2) - 2] == a
                    && content[i - (line_length * 3) - 3] == s
                {
                    answer += 1
                }
            }
        }
    }
    print("Part 1: \(answer), time: \(p1_time)")

    var answer2 = 0
    let p2_time: ContinuousClock.Instant.Duration = clock.measure {
        for (i, c) in content.enumerated() {
            let isM = c == m

            if i < (line_count - 2) * line_length {
                if content[i] == content[i + 2] && (c == m || c == s) {
                    if content[i + line_length + 1] == a {
                        if isM {
                            if content[i + 2 * line_length] == s
                                && content[i + 2 * line_length + 2] == s
                            {
                                answer2 += 1
                            }
                        } else {
                            if content[i + 2 * line_length] == m
                                && content[i + 2 * line_length + 2] == m
                            {
                                answer2 += 1
                            }
                        }
                    }
                }

                if isM {
                    if content[i + 2] == s {
                        if content[i + line_length + 1] == a {
                            if content[i + 2 * line_length] == m
                                && content[i + 2 * line_length + 2] == s
                            {
                                answer2 += 1

                            }
                        }
                    }
                } else if c == s {
                    if content[i + 2] == m {
                        if content[i + line_length + 1] == a {
                            if content[i + 2 * line_length] == s
                                && content[i + 2 * line_length + 2] == m
                            {
                                answer2 += 1

                            }
                        }
                    }
                }
            }
        }
    }
    print("Part 2: \(answer2), time: \(p2_time)")
}

main()