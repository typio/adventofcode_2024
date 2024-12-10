// Total time: 0.094 seconds

import Foundation

struct Walker {
    var p: Int
    var h: Int

    private let mw: Int
    private let mh: Int

    init(p: Int, h: Int, mw: Int, mh: Int) {
        self.p = p
        self.h = h
        self.mw = mw
        self.mh = mh
    }

    var ns: [Int] {
        var neighbors: [Int] = []
        if p > mw {
            neighbors += [p - mw]
        }
        if p < (mh - 1) * mw {
            neighbors += [p + mw]
        }
        if p % mw != 0 {
            neighbors += [p - 1]
        }
        if p % mw != (mw - 1) {
            neighbors += [p + 1]
        }
        return neighbors
    }
}

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day10.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var answer = 0
    var answer2 = 0
    let time = clock.measure {
        let lines = content.components(separatedBy: .newlines)

        var map: [Int] = []
        for line in lines {
            map.append(contentsOf: line.map { c in Int(String(c))! })
        }

        let mw = lines.first!.count
        let mh = lines.count

        var x = Walker(p: 0, h: 0, mw: mw, mh: mh)

        var starts: [Int] = []
        map.enumerated().forEach { (i, h) in
            if h == 0 {
                starts += [i]
            }
        }

        var paths: [[Int]] = starts.map { [$0] }
        var finished_paths: [[Int]] = []

        while paths.count > 0 {
            var to_remove: [Int] = []
            for (path_i, path) in paths.enumerated() {
                x.p = path.last!
                x.h = map[x.p]

                let nexts = x.ns.filter { map[$0] - x.h == 1 }

                if x.h == 9 {
                    finished_paths += [path]
                    to_remove += [path_i]
                } else if nexts.count == 0 {
                    to_remove += [path_i]
                } else {
                    for (next_i, next) in nexts.enumerated() {
                        if next_i == 0 {
                            paths[path_i] += [next]
                        } else {
                            paths += [(path + [next])]
                        }
                    }
                }
            }
            var new_paths: [[Int]] = []
            for (path_i, path) in paths.enumerated() {
                if !to_remove.contains(path_i) {
                    new_paths += [path]
                }
            }
            paths = new_paths

        }

        var unique_summits: [Int: Set<Int>] = [:]
        for path in finished_paths {
            if unique_summits[path.first!] == nil {
                unique_summits[path.first!] = Set([path.last!])
            } else {
                unique_summits[path.first!]?.insert(path.last!)
            }
        }

        for u in unique_summits {
            answer += u.value.count
        }

        answer2 = finished_paths.count
    }

    print("Part 1: \(answer), Part 2: \(answer2), time: \(time)")
}

main()
