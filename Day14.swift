// Total time: 0.019

import Foundation

func mod(_ a: Int, _ n: Int) -> Int {
    let r = a % n
    return r >= 0 ? r : r + n
}

func generateColors(_ count: Int) -> [String] {
    return (0..<count).map { i -> String in
        let colorCode = 16 + (215 * i / count)
        return "\u{001B}[38;5;\(colorCode)m"
    }
}

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day14.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    let w = 101
    let h = 103
    let seconds = 10000

    var answer = 0

    var robots: [((Int, Int), (Int, Int))] = []
    let lines = content.components(separatedBy: .newlines)

    var map: [[Int]] = Array(repeating: Array(repeating: -1, count: w), count: h)

    let robot_colors: [String] = generateColors(lines.count)

    let time = clock.measure {
        var quadrant_sums: [Int] = [0, 0, 0, 0]

        for line in lines {
            let parts = line.components(separatedBy: .whitespaces).map { part in
                var copy = part
                copy.removeSubrange(copy.startIndex..<copy.index(copy.startIndex, offsetBy: 2))
                return copy.components(separatedBy: ",").map { Int($0)! }
            }

            robots += [((parts[0][0], parts[0][1]), (parts[1][0], parts[1][1]))]
        }

        print("\u{001B}[?25l", terminator: "")  // hide cursor
        defer { print("\u{001B}[?25h", terminator: "") }  // show cursor

        let reset = "\u{001B}[0m"

        for t in 8000..<seconds {
            map = Array(repeating: Array(repeating: -1, count: w), count: h)

            for (robot_i, robot) in robots.enumerated() {
                let new_x = mod(robot.0.0 + robot.1.0 * t, w)
                let new_y = mod(robot.0.1 + robot.1.1 * t, h)
                // robots[robot_i].0.0 = new_x
                // robots[robot_i].0.1 = new_y

                map[new_y][new_x] = robot_i
            }

            for y in stride(from: 0, to: map.count - 1, by: 2) {
                for x in stride(from: 0, to: map[0].count - 1, by: 2) {
                    let topLeft = map[y][x]
                    let topRight = map[y][x + 1]
                    let bottomLeft = map[y + 1][x]
                    let bottomRight = map[y + 1][x + 1]

                    let color = robot_colors[
                        [topLeft, topRight, bottomLeft, bottomRight].first { n in
                            n != -1
                        } ?? 0]

                    let char =
                        switch (topLeft != -1, topRight != -1, bottomLeft != -1, bottomRight != -1)
                        {
                        case (false, false, false, false): " "
                        case (true, false, false, false): "▘"
                        case (false, true, false, false): "▝"
                        case (false, false, true, false): "▖"
                        case (false, false, false, true): "▗"
                        case (true, true, false, false): "▀"
                        case (false, false, true, true): "▄"
                        case (true, false, true, false): "▌"
                        case (false, true, false, true): "▐"
                        case (true, true, true, false): "▛"
                        case (true, true, false, true): "▜"
                        case (true, false, true, true): "▙"
                        case (false, true, true, true): "▟"
                        case (true, true, true, true): "█"
                        default: "▐"  // compromise for showing diagonals
                        }

                    print("\(color)\(char)\(reset)", terminator: "")
                }
                print()
            }
            print("second: \(t)")
            Thread.sleep(forTimeInterval: 0.05)

            print("\u{001B}[\(h / 2 + 1)A", terminator: "")

        }

        for robot in robots {
            if robot.0.0 == w / 2 || robot.0.1 == h / 2 {
                continue
            }

            quadrant_sums[((robot.0.0 > (w / 2)) ? 1 : 0) + ((robot.0.1 > (h / 2)) ? 2 : 0)] += 1
        }

        print("quadrant sums: \(quadrant_sums)")
        answer = quadrant_sums.reduce(1) { acc, curr in
            acc * curr
        }
    }

    print("Part 1: \(answer), time: \(time)")
}

main()
