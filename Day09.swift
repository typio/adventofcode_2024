// Total time: 5.140 seconds

import Foundation

struct Slot {
    // If id is nil this is only empty space
    var id: Int?
    var amt: Int
    var empty_space: Int
}

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day09.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var answer = 0
    var answer2 = 0
    let time = clock.measure {
        var disk_map: [Slot] = []
        var disk_map2: [Slot] = []

        disk_map.append(
            contentsOf: content.enumerated().map { i, n in
                let num = Int(String(n))!

                if i % 2 == 0 {
                    return Slot(
                        id: i / 2,
                        amt: num,
                        empty_space: 0
                    )
                } else {
                    return Slot(amt: 0, empty_space: num)
                }
            })

        disk_map2 = disk_map

        var first_empty_pos = 1
        var slot_i = disk_map.count - 1
        while slot_i > first_empty_pos {
            // if the empty slot can be filled convert it entirely
            if disk_map[slot_i].amt >= disk_map[first_empty_pos].empty_space {
                let fill_amt = disk_map[first_empty_pos].empty_space

                disk_map[first_empty_pos].id = disk_map[slot_i].id
                disk_map[first_empty_pos].amt = fill_amt
                disk_map[first_empty_pos].empty_space = 0

                disk_map[slot_i].amt -= fill_amt
                disk_map[slot_i].empty_space += fill_amt

                if disk_map[slot_i].amt == 0 {
                    disk_map[slot_i].id = nil
                }
            } else {
                // Move partial amount and create new empty slot for remainder
                let fill_amt = disk_map[slot_i].amt
                let remainder = disk_map[first_empty_pos].empty_space - fill_amt

                disk_map[first_empty_pos].id = disk_map[slot_i].id
                disk_map[first_empty_pos].empty_space -= fill_amt
                disk_map[first_empty_pos].amt = fill_amt
                disk_map[slot_i].amt = 0
                disk_map[slot_i].id = nil
                disk_map[slot_i].empty_space = fill_amt
                disk_map.insert(
                    contentsOf: [
                        Slot(amt: 0, empty_space: remainder)
                    ],
                    at: first_empty_pos + 1)
                disk_map[first_empty_pos].empty_space = 0
                first_empty_pos += 1
                slot_i += 1
            }

            // search for next empty slot
            while (disk_map[first_empty_pos].id != nil)
                && first_empty_pos < slot_i
            {
                first_empty_pos += 1
            }

            // search for next file
            while (disk_map[slot_i].id == nil) && slot_i > first_empty_pos {
                slot_i -= 1
            }
        }

        var i = 0
        for slot in disk_map {
            for j in i..<i + slot.amt {
                answer += ((slot.id ?? 0) * j)
            }
            i += slot.amt
        }

        // Part 2
        // size : pos
        var first_empty_dict: [Int: Int] = [:]
        for (idx, slot) in disk_map2.enumerated() {
            if idx % 2 != 0 && slot.empty_space > 0 && first_empty_dict[slot.empty_space] == nil {
                first_empty_dict[slot.empty_space] = idx
            }
            if first_empty_dict.keys.count == 9 {
                break
            }
        }

        func find_first_fitting_space(first_empty_dict: [Int: Int], amt: Int) -> (Int, Int)? {
            let res = first_empty_dict.reduce((Int.max, Int.max)) { acc, curr in
                let (size, pos) = curr
                if size >= amt && pos < acc.1 {
                    return (size, pos)
                } else {
                    return acc
                }
            }

            if res.1 == Int.max {
                return nil
            } else {
                return res
            }
        }

        slot_i = disk_map2.count - 1
        while slot_i > 0 {
            if disk_map2[slot_i].id == nil {
                slot_i -= 1
                continue
            }

            // if there is a slot that could fit it, move
            if let dest = find_first_fitting_space(
                first_empty_dict: first_empty_dict, amt: disk_map2[slot_i].amt)
            {
                let (dest_size, dest_pos) = dest
                if dest_pos > slot_i {
                    first_empty_dict[dest_size] = nil
                    slot_i -= 1
                    continue
                }
                let fill_amt = disk_map2[slot_i].amt
                let remainder = dest_size - fill_amt

                disk_map2[dest_pos].id = disk_map2[slot_i].id
                disk_map2[dest_pos].amt = fill_amt
                disk_map2[dest_pos].empty_space = 0

                // remove empty space from dict and look for another
                first_empty_dict[dest_size] = nil
                for w in 0...slot_i {
                    if disk_map2[w].empty_space == dest_size {
                        first_empty_dict[dest_size] = min(w, first_empty_dict[dest_size] ?? Int.max)
                        break
                    }
                }

                // convert slot to empty
                disk_map2[slot_i].amt = 0
                disk_map2[slot_i].empty_space = fill_amt
                disk_map2[slot_i].id = nil

                // create new empty slot with remainder
                if remainder > 0 {
                    disk_map2.insert(
                        contentsOf: [
                            Slot(amt: 0, empty_space: remainder)
                        ],
                        at: dest_pos + 1)

                    // inserting decrements slot_i

                    var updated_first_empty_dict: [Int: Int] = [:]
                    for (size, pos) in first_empty_dict {
                        if pos > dest_pos + 1 {
                            updated_first_empty_dict[size] = pos + 1
                        } else {
                            updated_first_empty_dict[size] = pos
                        }
                    }
                    first_empty_dict = updated_first_empty_dict

                    if dest_pos + 1 < first_empty_dict[remainder] ?? Int.max {
                        first_empty_dict[remainder] = dest_pos + 1
                    }
                }
            }

            slot_i -= 1
        }

        i = 0
        for slot in disk_map2 {
            for j in i..<i + slot.amt {
                answer2 += ((slot.id ?? 0) * j)
            }
            i += slot.amt + slot.empty_space
        }
    }

    print("Part 1: \(answer), Part 2: \(answer2), time: \(time)")
}

main()
