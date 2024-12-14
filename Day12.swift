// Total time: 5.289 seconds

import Foundation

struct Region {
    var map: [[Bool]]
    var area: Int = 0
    var perimeter: Int = 0
    var sides: Int = 0
    var letter: Character
}

// enum Dir: Int {
//     case Up = 0
//     case Left = 1
//     case Down = 2
//     case Right = 3
// }

// enum Turn: Int {
//     case Straight, Left, Right, Back
// }

// func make_turn(_ dir: Dir, turn: Turn) -> Dir {
//     switch turn {
//     case Turn.Left:
//         Dir(rawValue: (dir.rawValue + 1) % 4)!
//     case Turn.Right:
//         Dir(rawValue: (dir.rawValue + 3) % 4)!
//     case Turn.Back:
//         Dir(rawValue: (dir.rawValue + 2) % 4)!
//     case Turn.Straight:
//         dir
//     }
// }

struct Coord: Equatable, Hashable {
    var x: Int
    var y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    func ns(fw: Int, fh: Int) -> [Coord] {
        let coord = self
        var res: [Coord] = []

        // up
        if coord.y > 0 {
            res += [
                Coord(
                    coord.x, coord.y - 1)
            ]
        }
        // right
        if coord.x < fw - 1 {
            res += [
                Coord(
                    coord.x + 1, coord.y)
            ]
        }
        // down
        if coord.y < fh - 1 {
            res += [
                Coord(
                    coord.x, coord.y + 1)
            ]
        }
        // left
        if coord.x > 0 {
            res += [
                Coord(
                    coord.x - 1, coord.y)
            ]
        }

        return res
    }

    // func ns_8(fw: Int, fh: Int) -> [Coord] {
    //     let coord = self
    //     var res: [Coord] = []

    //     // up
    //     if coord.y > 0 {
    //         res += [Coord(coord.x, coord.y - 1)]
    //     }

    //     // right
    //     if coord.x < fw - 1 {
    //         res += [Coord(coord.x + 1, coord.y)]
    //     }

    //     // down
    //     if coord.y < fh - 1 {
    //         res += [Coord(coord.x, coord.y + 1)]
    //     }

    //     // left
    //     if coord.x > 0 {
    //         res += [Coord(coord.x - 1, coord.y)]
    //     }

    //     // up right
    //     if coord.y > 0 && coord.x < fw - 1 {
    //         res += [Coord(coord.x + 1, coord.y - 1)]
    //     }
    //     // right down
    //     if coord.x < fw - 1 && coord.y < fh - 1 {
    //         res += [Coord(coord.x + 1, coord.y + 1)]
    //     }
    //     // down left
    //     if coord.y < fh - 1 && coord.x > 0 {
    //         res += [Coord(coord.x - 1, coord.y + 1)]
    //     }
    //     // left up
    //     if coord.x > 0 && coord.y > 0 {
    //         res += [Coord(coord.x - 1, coord.y - 1)]
    //     }

    //     return res
    // }
}

// func legal_perimeter_moves(_ cell: Coord, dir: Dir, map: [[Bool]]) -> [Dir: Coord] {
//     if !map[cell.y][cell.x] { return [:] }

//     let fw = map.first!.count
//     let fh = map.count

//     return cell.ns(fw: fw, fh: fh).filter { (_, potential_dest) in
//         let neighbors_neighbors = potential_dest.ns_8(fw: fw, fh: fh)

//         return
//             map[potential_dest.y][potential_dest.x]
//             // on map edge
//             && (neighbors_neighbors.count < 8
//                 // borders non plot cell
//                 || (neighbors_neighbors.contains { neighbors_neighbor in
//                     !map[neighbors_neighbor.y][neighbors_neighbor.x]
//                 }))
//     }
// }

func main() {
    let clock = ContinuousClock()
    let filepath = URL.init(filePath: "Day12.txt")
    guard let content: String = try? String(contentsOf: filepath, encoding: .ascii) else {
        print("Failed to read file")
        return
    }

    var answer = 0
    var answer2 = 0
    let time = clock.measure {
        var farm: [[Character]] = []
        for (line) in content.components(separatedBy: .newlines) {
            farm += [line.map { $0 }]
        }

        let fw = farm[0].count
        let fh = farm.count

        var farm_visited: [[Bool]] = farm.map { $0.map { _ in false } }
        var regions: [Region] = []

        for (row_i, row) in farm.enumerated() {
            for (plant_i, plant) in row.enumerated() {
                if !farm_visited[row_i][plant_i] {
                    // flood fill
                    var region = Region(map: farm.map { $0.map { _ in false } }, letter: plant)
                    var neighbor_stack = [Coord(plant_i, row_i)]

                    while neighbor_stack.count > 0 {
                        let cell = neighbor_stack.removeLast()
                        farm_visited[cell.y][cell.x] = true

                        // needed because the same cell might be added to cell twice?
                        if !region.map[cell.y][cell.x] {
                            region.area += 1
                        }
                        region.map[cell.y][cell.x] = true

                        for n in cell.ns(fw: fw, fh: fh) {
                            if farm[n.y][n.x] == plant {
                                if !region.map[n.y][n.x] {
                                    neighbor_stack += [n]
                                }
                            }
                        }
                    }

                    regions += [region]
                }
            }
        }

        for (region_i, region) in regions.enumerated() {
            // This idea doesnt work lol
            // // find an outside cell, by finding any cell and then shooting a ray from left
            // var trace_cell = Coord(0, 0)
            // outerLoop: for y in 0..<fh {
            //     for x in 0..<fw {
            //         if region.map[y][x] == true {
            //             trace_cell.y = y
            //             for scan_x in 0...fw {
            //                 if region.map[y][scan_x] == true {
            //                     trace_cell.x = scan_x
            //                     break outerLoop
            //                 }
            //             }
            //         }
            //     }
            // }
            // let initial_trace_cell = trace_cell

            // // find initial direction
            // var dir = Dir.Right

            // // traverse perimeter, try to turn left, else go straight, else turn right
            // var visited_perimeter: Set<Coord> = .init()
            // repeat {

            //     let legal_moves = legal_perimeter_moves(trace_cell, dir: dir, map: region.map)

            //     var potential_nexts: [(Coord, dir: Dir, turn: Turn, visited: Bool, attempts: Int)] =
            //         []

            //     for (turn_i, turn) in [
            //         Turn.Left,
            //         Turn.Straight,
            //         Turn.Right,
            //         Turn.Back,
            //     ].enumerated() {
            //         let turned_dir = make_turn(dir, turn: turn)
            //         if legal_moves[turned_dir] != nil {
            //             let next = legal_moves[turned_dir]!
            //             potential_nexts += [
            //                 (
            //                     next, turned_dir, turn, visited_perimeter.contains(next),
            //                     turn_i + 1
            //                 )
            //             ]
            //             continue
            //         }
            //     }

            //     guard potential_nexts.count > 0 else {
            //         regions[region_i].perimeter = 4
            //         // print("\(region.letter) No moves found")
            //         break
            //     }

            //     let next = potential_nexts.first { !$0.visited } ?? potential_nexts.first!

            //     dir = next.dir

            //     if !visited_perimeter.contains(trace_cell) {
            //         regions[region_i].perimeter +=
            //             4
            //             - trace_cell
            //             .ns(fw: fw, fh: fh).values
            //             .filter { region.map[$0.y][$0.x] }
            //             .count
            //         visited_perimeter.insert(trace_cell)
            //     }

            //     trace_cell = next.0
            // } while trace_cell != initial_trace_cell

            // TODO: accelerate by remembering x y range of region
            for (row_i, row) in region.map.enumerated() {
                for (plant_i, plant) in row.enumerated() {
                    let cell = Coord(plant_i, row_i)

                    if plant {
                        regions[region_i].perimeter +=
                            4
                            - cell.ns(fw: fw, fh: fh).filter({ n in
                                region.map[n.y][n.x]
                            }).count

                        // exterior corners
                        // top left corner
                        var c1 = row_i > 0 ? region.map[row_i - 1][plant_i] : false
                        var c2 = plant_i > 0 ? region.map[row_i][plant_i - 1] : false
                        if !c1 && !c2 {
                            regions[region_i].sides += 1
                        }
                        // top right corner
                        c1 = row_i > 0 ? region.map[row_i - 1][plant_i] : false
                        c2 = plant_i < fw - 1 ? region.map[row_i][plant_i + 1] : false
                        if !c1 && !c2 {
                            regions[region_i].sides += 1
                        }
                        // bottom left corner
                        c1 = row_i < fh - 1 ? region.map[row_i + 1][plant_i] : false
                        c2 = plant_i > 0 ? region.map[row_i][plant_i - 1] : false
                        if !c1 && !c2 {
                            regions[region_i].sides += 1
                        }
                        // bottom right corner
                        c1 = row_i < fh - 1 ? region.map[row_i + 1][plant_i] : false
                        c2 = plant_i < fw - 1 ? region.map[row_i][plant_i + 1] : false
                        if !c1 && !c2 {
                            regions[region_i].sides += 1
                        }
                    } else {
                        // inside corners
                        // top left corner
                        var c1 = row_i > 0 ? region.map[row_i - 1][plant_i] : false
                        var c2 = plant_i > 0 ? region.map[row_i][plant_i - 1] : false
                        var c3 = row_i > 0 && plant_i > 0 ? region.map[row_i - 1][plant_i - 1] : false
                        if c1 && c2 && c3 {
                            regions[region_i].sides += 1
                        }
                        // top right corner
                        c1 = row_i > 0 ? region.map[row_i - 1][plant_i] : false
                        c2 = plant_i < fw - 1 ? region.map[row_i][plant_i + 1] : false
                        c3 = row_i > 0 && plant_i < fw - 1 ? region.map[row_i - 1][plant_i + 1] : false
                        if c1 && c2 && c3 {
                            regions[region_i].sides += 1
                        }
                        // bottom left corner
                        c1 = row_i < fh - 1 ? region.map[row_i + 1][plant_i] : false
                        c2 = plant_i > 0 ? region.map[row_i][plant_i - 1] : false
                        c3 = row_i < fh - 1 && plant_i > 0 ? region.map[row_i + 1][plant_i - 1] : false
                        if c1 && c2 && c3 {
                            regions[region_i].sides += 1
                        }
                        // bottom right corner
                        c1 = row_i < fh - 1 ? region.map[row_i + 1][plant_i] : false
                        c2 = plant_i < fw - 1 ? region.map[row_i][plant_i + 1] : false
                        c3 = row_i < fh - 1 && plant_i < fw - 1  ? region.map[row_i + 1][plant_i + 1] : false
                        if c1 && c2 && c3 {
                            regions[region_i].sides += 1
                        }
                    }
                }
            }
        }

        for region in regions {
            print(
                "plant: \(region.letter), s: \(region.sides)"
            )
            answer += region.area * region.perimeter
            answer2 += region.area * region.sides
        }
    }

    print("Part 1: \(answer), Part 2: \(answer2), time: \(time)")
}

main()
