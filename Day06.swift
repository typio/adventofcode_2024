// Total time: 3.13 seconds

import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day06.txt")
    guard var content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    enum Dir: Int {
        case Up = 0
        case Right, Down, Left

        var next: Dir { Dir(rawValue: (self.rawValue + 1) % 4)! }
    }
    var dir = Dir.Up
    var map: [Bool] = []
    var visited: [[Dir]] = []
    var visited_list: [Int] = []
    var guard_pos: Int = 0
    var initial_guard_pos: Int = 0
    var line_length = 0
    var answer = 0
    var answer2 = 0
    var potential_looping_obstacles: [Bool] = []
    let time = clock.measure {
        line_length =
            content.distance(
                from: content.startIndex, to: content.firstIndex(of: "\n")!)

        content = content.filter { $0 != "\n" }
        map = content.map { $0 == "#" }

        visited = [[Dir]](repeating: [], count: map.count)
        potential_looping_obstacles = [Bool](repeating: false, count: map.count)

        guard_pos = Array(content.utf8).firstIndex { c in
            c == Character("^").asciiValue!
        }!
        initial_guard_pos = guard_pos

        visited[initial_guard_pos] = [.Up]

        func get_next_pos(pos: Int, dir: Dir) -> Int {
            return pos
                + (dir == .Up ? -line_length : dir == .Right ? 1 : dir == .Down ? line_length : -1)
        }

        while true {
            let next_pos =
                get_next_pos(pos: guard_pos, dir: dir)

            if next_pos < 0 || next_pos > map.count - 1
                || (guard_pos % line_length == 0 && dir == .Right)
                || (guard_pos % line_length == line_length - 1 && dir == .Left)
            {
                break
            }

            if map[next_pos] {
                dir = dir.next
            } else {
                guard_pos = next_pos
                visited[guard_pos].append(contentsOf: [dir])
                visited_list.append(contentsOf: [guard_pos])
            }
        }

        func will_loop(pos: Int) -> Bool {
            var map_with_new_obstacle = map
            map_with_new_obstacle[pos] = true

            var test_pos = initial_guard_pos
            var test_dir = Dir.Up
            var seen: Set<Int> = []

            while true {
                let next_pos = get_next_pos(pos: test_pos, dir: test_dir)

                if next_pos < 0 || next_pos >= map_with_new_obstacle.count
                    || (test_pos % line_length == 0 && test_dir == .Right)
                    || (test_pos % line_length == line_length - 1 && test_dir == .Left)
                {
                    return false
                }

                let state = test_pos * 4 + test_dir.rawValue
                if seen.contains(state) {
                    return true
                }
                seen.insert(state)

                if map_with_new_obstacle[next_pos] {
                    test_dir = test_dir.next
                } else {
                    test_pos = next_pos
                }
            }
        }

        guard_pos = initial_guard_pos
        for pos in visited_list {
            if pos != initial_guard_pos && will_loop(pos: pos) {
                potential_looping_obstacles[pos] = true
            }
        }

        answer = visited.reduce(
            0,
            { acc, curr in
                acc + ((curr.count > 0) ? 1 : 0)
            })

        answer2 = potential_looping_obstacles.reduce(
            0,
            { acc, curr in
                acc + (curr ? 1 : 0)
            })
    }
    print("Part 1: \(answer), Part 2: \(answer2), time: \(time)")
}

main()
