// Total time: 0.001190041

import Foundation

struct Coord: Hashable {
    var x: Int
    var y: Int
}

extension Coord {
    static func - (lhs: Self, rhs: Self) -> Coord {
        return Coord(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func + (lhs: Self, rhs: Self) -> Coord {
        return Coord(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    func inBounds(outer_x: Int, outer_y: Int) -> Bool {
        return (self.x >= 0 && self.y >= 0) && (self.x < outer_x && self.y < outer_y)
    }
}

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day08.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var antennas: [Character: [Coord]] = [:]
    var antinodes: Set<Coord> = []
    var antinodes2: Set<Coord> = []

    var line_count = 0
    var line_length = 0

    let time = clock.measure {
        let lines = content.components(separatedBy: .newlines)
        line_count = lines.count
        line_length = lines[0].count
        for (i, line) in lines.enumerated() {
            for (j, char) in line.enumerated() {
                if char != "." {
                    var pos_list: [Coord] = antennas[char] ?? []
                    pos_list.append(contentsOf: [Coord(x: j, y: i)])
                    antennas[char] = pos_list
                }
            }
        }

        for (_, positions) in antennas {
            for i in 0..<(positions.count) {
                for j in 0..<positions.count {
                    if i == j { continue }

                    let p1 = positions[i]
                    let p2 = positions[j]

                    let d = Coord(x: p2.x - p1.x, y: p2.y - p1.y)

                    var a1 = Coord(x: p1.x, y: p1.y) - d
                    var a2 = Coord(x: p2.x, y: p2.y) + d

                    // Part 1
                    if a1.inBounds(outer_x: line_length, outer_y: line_count) {
                        antinodes.insert(a1)
                    }

                    if a2.inBounds(outer_x: line_length, outer_y: line_count) {
                        antinodes.insert(a2)
                    }

                    a1 = Coord(x: p1.x, y: p1.y) + d
                    a2 = Coord(x: p2.x, y: p2.y) - d

                    // Part 2
                    while a1.inBounds(outer_x: line_length, outer_y: line_count) {
                        antinodes2.insert(a1)
                        a1 = a1 + d
                    }

                    while a2.inBounds(outer_x: line_length, outer_y: line_count) {
                        antinodes2.insert(a2)
                        a2 = a2 - d
                    }
                }
            }
        }

        // for (i, line) in lines.enumerated() {
        //     var str = ""
        //     for (j, char) in line.enumerated() {
        //         if antinodes.contains(Coord(x: j, y: i)) {
        //             str += "#"
        //         } else {
        //             str += String(char)
        //         }
        //     }
        //     print(str)
        // }
    }

    print("Part 1: \(antinodes.count), Part 2: \(antinodes2.count), time: \(time)")
}

main()
