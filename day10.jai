day10 :: () {
    part1_example, part2_example := day10_example();
    part1_input, part2_input := day10_input();

    print("day10 part1 example: \t%\n", part1_example);
    print("day10 part1: \t\t%\n",       part1_input);
    print("day10 part2 example: \t%\n", part2_example);
    print("day10 part2: \t\t%\n",       part2_input);

    assert(part1_example == 80);
    assert(part1_input   == 6867);
    assert(part2_example == 10);
    assert(part2_input   == 595);
}

day10_example :: () -> part1: int, part2: int {
    input, success := #run read_entire_file("data/day10_example.txt");
    assert(success);

    part1, part2 := day10_2_solve(input);
    return part1, part2;
}

day10_input :: () -> part1: int, part2: int {
    input, success := read_entire_file("data/day10.txt");
    assert(success);

    part1, part2 := day10_2_solve(input);
    return part1, part2;
}

day10_2_solve :: (input: string) -> part1: int, part2: int {
    Map :: struct {
        map: []string;
        width: int;
        height: int;
        loop_cells: [..] v2s;
    }

    find_start :: (map: Map) -> x: int, y: int {
        for line, y: map.map {
            for c, x: cast([]u8) line {
                if c == #char "S" {
                    return x, y;
                }
            }
        }

        print("=== Error ===\n");
        return 0, 0;
    }

    get_cell :: (map: Map, x: int, y: int) -> cell: u8 {
        is_out_of_bound := x < 0 || x >= map.width || y < 0 || y >= map.height;
        if is_out_of_bound {
            return 0;
        }

        return map.map[y].data[x];
    }

    get_neighbour_directions :: (cell: u8) -> v2s, v2s {
        // |, -, F, 7, J, L
        if cell == #char "|" {
            return .{0, -1}, .{0, 1};
        }
        if cell == #char "-" {
            return .{-1, 0}, .{1, 0};
        }
        if cell == #char "F" {
            return .{1, 0}, .{0, 1};
        }
        if cell == #char "7" {
            return .{-1, 0}, .{0, 1};
        }
        if cell == #char "J" {
            return .{0, -1}, .{-1, 0};
        }
        if cell == #char "L" {
            return .{0, -1}, .{1, 0};
        }

        print("cell: %\n", character_to_string(cell));
        assert(false, "get_neighbour_directions: invalid cell");
        return .{}, .{};
    }

    get_next_position :: (
        current_x: int,
        current_y: int,
        previous_x: int,
        previous_y: int,
        cell: u8,
        map: Map
    ) -> x: int, y: int {
        direction1, direction2 := get_neighbour_directions(cell);

        if current_x + direction1.x == previous_x && current_y + direction1.y == previous_y {
            return current_x + direction2.x, current_y + direction2.y;
        } else {
            return current_x + direction1.x, current_y + direction1.y;
        }
    }

    get_start_tile :: (map: Map, x: int, y: int) -> u8 {
        hash := 0;

        top := get_cell(map, x, y - 1);
        right := get_cell(map, x + 1, y);
        bottom := get_cell(map, x, y + 1);
        left := get_cell(map, x - 1, y);

        if top == #char "|" || top == #char "F" || top == #char "7" {
            hash |= 0b0001;
        }
        if right == #char "-" || right == #char "7" || right == #char "J" {
            hash |= 0b0010;
        }
        if bottom == #char "|" || bottom == #char "J" || bottom == #char "L" {
            hash |= 0b0100;
        }
        if left == #char "-" || left == #char "L" || left == #char "F" {
            hash |= 0b1000;
        }

        table: [0b1111] u8;
        table[0b0101] = #char "|";
        table[0b1010] = #char "-";
        table[0b1001] = #char "J";
        table[0b0011] = #char "L";
        table[0b0110] = #char "F";
        table[0b1100] = #char "7";

        return table[hash];
    }

    lines := split(copy_string(input), "\n");
    // Remove last line if empty.
    if lines[lines.count - 1].count == 0 lines.count -= 1;

    map: Map;
    map.map    = lines;
    map.width  = lines[0].count;
    map.height = lines.count;

    moves := 0;
    start_x, start_y := find_start(map);

    map.map[start_y].data[start_x] = get_start_tile(map, start_x, start_y);

    previous_x, previous_y := -1, -1;
    x, y := start_x, start_y;

    array_add(*map.loop_cells, .{start_x, start_y});

    while true {
        cell := get_cell(map, x, y);

        if moves != 0 && x == start_x && y == start_y break;

        array_add(*map.loop_cells, .{x, y});

        new_x, new_y := get_next_position(
            x,
            y,
            previous_x,
            previous_y,
            cell,
            map,
        );

        previous_x, previous_y = x, y;
        x, y = new_x, new_y;
        moves += 1;
    }

    inside_cells: [..] v2s;
    segment_start: u8;

    for y: 0..map.height - 1 {
        is_inside := false;

        for x: 0..map.width - 1 {
            position := v2s.{x, y};
            cell := get_cell(map, x, y);

            if array_contains(map.loop_cells, position) {
                if cell == #char "F" || cell == #char "L" {
                    segment_start = cell;
                    print_color("%", character_to_string(cell), color=.BLUE);
                } else if cell == #char "-" {
                    // Pass.
                    print_color("%", character_to_string(cell), color=.BLUE);
                } else if cell == #char "7" {
                    if segment_start == #char "L" {
                        is_inside = !is_inside;
                        print_color("%", character_to_string(cell), color=.GREEN);
                    } else {
                        print_color("%", character_to_string(cell), color=.BLUE);
                    }
                } else if cell == #char "J" {
                    if segment_start == #char "F" {
                        is_inside = !is_inside;
                        print_color("%", character_to_string(cell), color=.GREEN);
                    } else {
                        print_color("%", character_to_string(cell), color=.BLUE);
                    }
                } else {
                    is_inside = !is_inside;
                    print_color("%", character_to_string(cell), color=.GREEN);
                }
            } else {
                if is_inside {
                    array_add(*inside_cells, position);
                    print_color("%", character_to_string(cell), color=.YELLOW);
                } else {
                    print("%", character_to_string(cell));
                }
            }
        }

        print("\n");
    }
    print("\n");

    return moves / 2, inside_cells.count;
}

v2s :: struct {
    x: int;
    y: int;
}

operator == :: (a: v2s, b: v2s) -> bool {
    return a.x == b.x && a.y == b.y;
}
