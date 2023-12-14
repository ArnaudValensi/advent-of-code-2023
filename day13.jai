day13 :: () {
    result_day13_1_example := day13_1_example();
    result_day13_1_input   := day13_1_input();
    result_day13_2_example := day13_2_example();
    result_day13_2_input   := day13_2_input();

    print("day13 part1 example: \t%\n", result_day13_1_example);
    print("day13 part1: \t\t%\n",       result_day13_1_input);
    print("day13 part2 example: \t%\n", result_day13_2_example);
    print("day13 part2: \t\t%\n",       result_day13_2_input);

    assert(result_day13_1_example == 405);
    assert(result_day13_1_input   == 32371);
    assert(result_day13_2_example == 400);
    assert(result_day13_2_input == 37416);
}

day13_1_example :: () -> int {
    input, success := #run read_entire_file("data/day13_1_example.txt");
    assert(success);

    return day13_1_solve(input);
}

day13_1_input :: () -> int {
    input, success := read_entire_file("data/day13.txt");
    assert(success);

    return day13_1_solve(input);
}

day13_2_example :: () -> int {
    input, success := #run read_entire_file("data/day13_1_example.txt");
    assert(success);

    return day13_2_solve(input);
}

day13_2_input :: () -> int {
    input, success := read_entire_file("data/day13.txt");
    assert(success);

    return day13_2_solve(input);
}

day13_1_solve :: (raw_input: string) -> int {
    // Pretty print arrays.
    context.print_style.default_format_array.separator    = ",\n";
    context.print_style.default_format_array.begin_string = "[\n";
    context.print_style.default_format_array.end_string   = "\n]";

    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    patterns := split(input, "\n\n");

    are_columns_equal :: (map: [][]u8, x1: int, x2: int) -> bool {
        height := map.count;

        for y: 0..height - 1 {
            if map[y][x1] != map[y][x2] {
                return false;
            }
        }

        return true;
    }

    are_rows_equal :: (map: [][]u8, y1: int, y2: int) -> bool {
        width := map[0].count;

        for x: 0..width - 1 {
            if map[y1][x] != map[y2][x] {
                return false;
            }
        }

        return true;
    }

    compute_vertical_mirror :: (map: [][]u8) -> int {
        width := map[0].count;
        height := map.count;

        result := 0;
        for x: 0..width - 2 {
            is_mirror := true;

            if !are_columns_equal(map, x, x + 1) {
                continue;
            }

            min_side_length := min(x + 1, width - x - 1);

            for i: 0..min_side_length - 1 {
                x1 := x - i;
                x2 := x + i + 1;

                if !are_columns_equal(map, x1, x2) {
                    continue x;
                }
            }

            tmp_result := x + 1;
            if tmp_result > result result = tmp_result;
        }

        return result;
    }

    compute_horizontal_mirror :: (map: [][]u8) -> int {
        width := map[0].count;
        height := map.count;

        result := 0;
        for y: 0..height - 2 {
            is_mirror := true;

            if !are_rows_equal(map, y, y + 1) {
                continue;
            }

            min_side_length := min(y + 1, height - y - 1);

            for i: 0..min_side_length - 1 {
                y1 := y - i;
                y2 := y + i + 1;

                if !are_rows_equal(map, y1, y2) {
                    continue y;
                }
            }

            tmp_result := y + 1;
            if tmp_result > result result = tmp_result;
        }

        return result;
    }

    result := 0;

    for pattern: patterns {
        lines := split(pattern, "\n");
        map: [..][]u8;

        for line: lines {
            array_add(*map, cast([]u8) line);
        }

        vertical := compute_vertical_mirror(map);
        horizontal := compute_horizontal_mirror(map);

        result += vertical + 100 * horizontal;
    }

    return result;
}

day13_2_solve :: (raw_input: string) -> int {
    // Pretty print arrays.
    context.print_style.default_format_array.separator    = ",\n";
    context.print_style.default_format_array.begin_string = "[\n";
    context.print_style.default_format_array.end_string   = "\n]";

    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    patterns := split(input, "\n\n");

    are_columns_equal :: (map: [][]u8, x1: int, x2: int) -> bool {
        height := map.count;

        for y: 0..height - 1 {
            if map[y][x1] != map[y][x2] {
                return false;
            }
        }

        return true;
    }

    are_rows_equal :: (map: [][]u8, y1: int, y2: int) -> bool {
        width := map[0].count;

        for x: 0..width - 1 {
            if map[y1][x] != map[y2][x] {
                return false;
            }
        }

        return true;
    }

    compute_vertical_mirror :: (map: [][]u8, ignore: int) -> int {
        width := map[0].count;
        height := map.count;

        for x: 0..width - 2 {
            is_mirror := true;

            if !are_columns_equal(map, x, x + 1) {
                continue;
            }

            min_side_length := min(x + 1, width - x - 1);

            for i: 0..min_side_length - 1 {
                x1 := x - i;
                x2 := x + i + 1;

                if !are_columns_equal(map, x1, x2) {
                    continue x;
                }
            }

            result := x + 1;
            if result != ignore {
                return result;
            }
        }

        return 0;
    }

    compute_horizontal_mirror :: (map: [][]u8, ignore: int) -> int {
        width := map[0].count;
        height := map.count;

        for y: 0..height - 2 {
            is_mirror := true;

            if !are_rows_equal(map, y, y + 1) {
                continue;
            }

            min_side_length := min(y + 1, height - y - 1);

            for i: 0..min_side_length - 1 {
                y1 := y - i;
                y2 := y + i + 1;

                if !are_rows_equal(map, y1, y2) {
                    continue y;
                }
            }

            result := y + 1;
            if result != ignore {
                return result;
            }
        }

        return 0;
    }

    copy_map :: (dest: *[..][]u8, source: [][]u8) {
        for << dest {
            array_free(it);
        }
        array_reset_keeping_memory(dest);

        for row: source {
            copy: []u8 = array_copy(row);
            array_add(dest, copy);
        }
    }

    result := 0;

    current_map: [..][]u8;

    for pattern: patterns {
        lines := split(pattern, "\n");

        original_map: [..][]u8;

        for line: lines {
            array_add(*original_map, cast([]u8) line);
        }

        width := original_map[0].count;
        height := original_map.count;

        original_x := compute_vertical_mirror(original_map, -1);
        original_y := compute_horizontal_mirror(original_map, -1);

        for y: 0..height - 1 {
            for x: 0..width - 1 {
                copy_map(*current_map, original_map);

                if current_map[y][x] == #char "." {
                    current_map[y][x] = #char "#";
                } else {
                    current_map[y][x] = #char ".";
                }

                vertical := compute_vertical_mirror(current_map, original_x);
                horizontal := compute_horizontal_mirror(current_map, original_y);

                if vertical != 0 || horizontal != 0 {
                    result += vertical + 100 * horizontal;
                    continue pattern;
                }
            }
        }
    }

    return result;
}
