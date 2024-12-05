// Part 1: 0.029967208 seconds
// Part 2: 1.2333e-05 seconds

import Foundation

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day05.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var answer = 0

    var rules: [Int: [Int]] = [:]
    var sequences: [[Int]] = []

    var incorrect_sorted_seqs: [[Int]] = []

    let p1_time = clock.measure {
        let parts = content.components(separatedBy: "\n\n")

        parts[0].components(separatedBy: .newlines).forEach {
            let before_after: [Int] = $0.components(separatedBy: "|").map { Int($0)! }
            if rules[before_after[0]] != nil {
                rules[before_after[0]]!.append(contentsOf: [before_after[1]])
            } else {
                rules[before_after[0]] = [before_after[1]]
            }
        }

        sequences = parts[1].components(separatedBy: .newlines).map { line in
            line.components(separatedBy: ",").map { Int($0)! }
        }
        for sequence in sequences {
            let sorted_sequence = sequence.aoc_sort(rules: rules)

            if sequence == sorted_sequence {
                answer += sequence[Int(floor(Double(sequence.count) / 2))]
            } else {
                incorrect_sorted_seqs.append(sorted_sequence)
            }
        }
    }
    print("Part 1: \(answer), time: \(p1_time)")

    var answer2 = 0
    let p2_time = clock.measure {
        for incorrect_sorted_seq in incorrect_sorted_seqs {
            answer2 += incorrect_sorted_seq[Int(floor(Double(incorrect_sorted_seq.count) / 2))]
        }
    }
    print("Part 2: \(answer2), time: \(p2_time)")
}

extension [Int] {
    func aoc_sort(rules: [Int: [Int]]) -> [Int] {
        return self.sorted { b, a in
            if rules[a] != nil {
                if rules[a]!.contains(b) {
                    return false
                }
            } else if rules[b] != nil {
                if rules[b]!.contains(a) {
                    return true
                }
            }
            return true
        }
    }
}

main()
