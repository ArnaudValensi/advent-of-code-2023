day14 :: () {
    result_day14_1_example := day14_1_example();
    result_day14_1_input   := day14_1_input();
    result_day14_2_example := day14_2_example();
    result_day14_2_input   := day14_2_input();

    print("day14 part1 example: \t%\n", result_day14_1_example);
    print("day14 part1: \t\t%\n",       result_day14_1_input);
    print("day14 part2 example: \t%\n", result_day14_2_example);
    print("day14 part2: \t\t%\n",       result_day14_2_input);

    assert(result_day14_1_example == 136);
    assert(result_day14_1_input   == 112048);
    assert(result_day14_2_example == 64);
    assert(result_day14_2_input == 105606);
}

day14_1_example :: () -> int {
    input, success := #run read_entire_file("data/day14_1_example.txt");
    assert(success);

    return day14_1_solve(input);
}

day14_1_input :: () -> int {
    input, success := read_entire_file("data/day14.txt");
    assert(success);

    return day14_1_solve(input);
}

day14_2_example :: () -> int {
    input, success := #run read_entire_file("data/day14_1_example.txt");
    assert(success);

    return day14_2_solve(input);
}

day14_2_input :: () -> int {
    input, success := read_entire_file("data/day14.txt");
    assert(success);

    return day14_2_solve(input);
}

day14_1_solve :: (raw_input: string) -> int {
    sort_column :: (map: *[][]u8, x: int) {
        height := map.count;

        y := 1;
        while true {
            current_cell: u8 = map.data[y][x];
            previous_cell: u8 = map.data[y - 1][x];

            if current_cell == #char "O" && previous_cell == #char "." {
                map.data[y][x] = #char ".";
                map.data[y - 1][x] = #char "O";
                y = 1;
                continue;
            }

            y += 1;
            if y == height return;
        }
    }

    get_load :: (map: [][]u8) -> int {
        sum := 0;
        for row, row_index: map {
            for cell: row {
                if cell == #char "O" {
                    sum += map.count - row_index;
                }
            }
        }
        return sum;
    }

    print_map :: (map: [][]u8) {
        print("\n");
        for row: map {
            print("%\n", cast(string) row);
        }
        print("\n");
    }

    // Pretty print arrays.
    context.print_style.default_format_array.separator    = ",\n";
    context.print_style.default_format_array.begin_string = "[\n";
    context.print_style.default_format_array.end_string   = "\n]";

    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    lines := split(input, "\n");

    map: [..][]u8;
    for line: lines {
        array_add(*map, cast([]u8) line);
    }

    width := map[0].count;

    for x: 0..width - 1 {
        sort_column(*map, x);
    }

    return get_load(map);
}

day14_2_solve :: (raw_input: string) -> int {
    sort_column_north :: (map: *[][]u8, x: int) {
        height := map.count;

        y := 1;
        while true {
            current_cell: u8 = map.data[y][x];
            previous_cell: u8 = map.data[y - 1][x];

            if current_cell == #char "O" && previous_cell == #char "." {
                map.data[y][x] = #char ".";
                map.data[y - 1][x] = #char "O";
                y = 1;
                continue;
            }

            y += 1;
            if y == height return;
        }
    }

    sort_column_south :: (map: *[][]u8, x: int) {
        height := map.count;

        y := height - 2;
        while true {
            current_cell: u8 = map.data[y][x];
            previous_cell: u8 = map.data[y + 1][x];

            if current_cell == #char "O" && previous_cell == #char "." {
                map.data[y][x] = #char ".";
                map.data[y + 1][x] = #char "O";
                y = height - 2;
                continue;
            }

            y -= 1;
            if y < 0 return;
        }
    }

    sort_column_west :: (map: *[][]u8, y: int) {
        width := map[0].count;

        x := 1;
        while true {
            current_cell: u8 = map.data[y][x];
            previous_cell: u8 = map.data[y][x - 1];

            if current_cell == #char "O" && previous_cell == #char "." {
                map.data[y][x] = #char ".";
                map.data[y][x - 1] = #char "O";
                x = 1;
                continue;
            }

            x += 1;
            if x == width return;
        }
    }

    sort_column_east :: (map: *[][]u8, y: int) {
        width := map[0].count;

        x := width - 2;
        while true {
            current_cell: u8 = map.data[y][x];
            previous_cell: u8 = map.data[y][x + 1];

            if current_cell == #char "O" && previous_cell == #char "." {
                map.data[y][x] = #char ".";
                map.data[y][x + 1] = #char "O";
                x = width - 2;
                continue;
            }

            x -= 1;
            if x < 0 return;
        }
    }

    get_load :: (map: [][]u8) -> int {
        sum := 0;
        for row, row_index: map {
            for cell: row {
                if cell == #char "O" {
                    sum += map.count - row_index;
                }
            }
        }
        return sum;
    }

    print_map :: (map: [][]u8) {
        print("\n");
        for row: map {
            print("%\n", cast(string) row);
        }
        print("\n");
    }

    // Pretty print arrays.
    context.print_style.default_format_array.separator    = ",\n";
    context.print_style.default_format_array.begin_string = "[\n";
    context.print_style.default_format_array.end_string   = "\n]";

    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    lines := split(input, "\n");

    map: [..][]u8;
    for line: lines {
        array_add(*map, cast([]u8) line);
    }

    num_cycles := 1000000000;

    next_cycle :: (map: *[][]u8) -> int {
        width := map[0].count;
        height := map.count;

        for x: 0..width - 1 {
            sort_column_north(map, x);
        }
        for y: 0..height - 1 {
            sort_column_west(map, y);
        }
        for x: 0..width - 1 {
            sort_column_south(map, x);
        }
        for y: 0..height - 1 {
            sort_column_east(map, y);
        }

        return get_load(<<map);
    }

    seen: Table(int, int);
    sequence: [..]int;
    cycle_start: int = -1;
    cycle_length: int = -1;
    diff: int = 0;

    while true {
        value := next_cycle(*map);
        array_add(*sequence, value);

        prev_index, is_seen := table_find(*seen, value);
        if is_seen && cycle_start == -1 && sequence.count - prev_index > 7 {
            cycle_start = prev_index;
            cycle_length = 1;
            diff = sequence.count - cycle_start;
        } else if cycle_start != -1 {
            if value == sequence[cycle_start + cycle_length] {
                cycle_length += 1;

                if cycle_length == diff {
                    break;
                }
            } else {
                cycle_start = -1;
                cycle_length = -1;
            }

        }

        table_set(*seen, value, sequence.count - 1);
    }

    return sequence[cycle_start + (num_cycles - cycle_start - 1) % (cycle_length - 1)];
}
