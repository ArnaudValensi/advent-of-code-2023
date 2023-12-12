day11 :: () {
    result_day11_1_example := day11_1_example();
    result_day11_1_input   := day11_1_input();
    result_day11_2_example := day11_2_example();
    result_day11_2_input   := day11_2_input();

    print("day11 part1 example: \t%\n", result_day11_1_example);
    print("day11 part1: \t\t%\n",       result_day11_1_input);
    print("day11 part2 example: \t%\n", result_day11_2_example);
    print("day11 part2: \t\t%\n",       result_day11_2_input);

    assert(result_day11_1_example == 374);
    assert(result_day11_1_input   == 9918828);
    assert(result_day11_2_example == 82000210);
    assert(result_day11_2_input   == 692506533832);
}

day11_1_example :: () -> int {
    input, success := #run read_entire_file("data/day11_1_example.txt");
    assert(success);

    return day11_1_solve(input);
}

day11_1_input :: () -> int {
    input, success := read_entire_file("data/day11.txt");
    assert(success);

    return day11_1_solve(input);
}

day11_2_example :: () -> int {
    input, success := #run read_entire_file("data/day11_1_example.txt");
    assert(success);

    return day11_2_solve(input);
}

day11_2_input :: () -> int {
    input, success := read_entire_file("data/day11.txt");
    assert(success);

    return day11_2_solve(input);
}

day11_1_solve :: (input: string) -> int {
    Map :: struct {
        map: [..][..]u8;
        width: int;
        height: int;
    }

    lines := split(copy_string(input), "\n");
    // Remove last line if empty.
    if lines[lines.count - 1].count == 0 lines.count -= 1;

    map: Map;

    for row: lines {
        map_row: [..]u8;
        for cell: cast([]u8) row {
            array_add(*map_row, cell);
        }

        array_add(*map.map, map_row);
    }

    map.width  = map.map[0].count;
    map.height = map.map.count;

    // Identify empty rows and columns.

    empty_rows: [..] int;
    empty_columns: [..] int;

    for y: 0..map.height - 1 {
        empty_row := true;

        for x: 0..map.width - 1 {
            cell := map.map[y][x];
            if cell == #char "#" {
                empty_row = false;
            }
        }

        if empty_row {
            array_add(*empty_rows, y);
        }
    }

    for x: 0..map.width - 1 {
        empty_column := true;

        for y: 0..map.height -1 {
            cell := map.map[y][x];
            if cell == #char "#" {
                empty_column = false;
            }
        }

        if empty_column {
            array_add(*empty_columns, x);
        }
    }

    // Expand the grid.

    expanded_grid: [..][..]u8;
    galaxies: [..][2]int;

    for y: 0..map.height - 1 {
        expanded_row: [..]u8;

        for x: 0..map.width - 1 {
            cell := map.map[y][x];
            array_add(*expanded_row, cell);

            if array_contains(empty_columns, x) {
                array_add(*expanded_row, #char ".");
            }

            if (cell == #char "#") {
                array_add(*galaxies, .[expanded_row.count - 1, expanded_grid.count]);
            }
        }

        array_add(*expanded_grid, expanded_row);

        if array_contains(empty_rows, y) {
            array_add(*expanded_grid, expanded_row);
        }
    }

    sum := 0;
    for i: 0..galaxies.count - 1 {
        for j: i + 1..galaxies.count - 1 {
            distance := abs(galaxies[i][0] - galaxies[j][0]) +
                        abs(galaxies[i][1] - galaxies[j][1]);
            sum += distance;
        }
    }

    return sum;
}

day11_2_solve :: (input: string) -> int {
    Map :: struct {
        map: [..][..]u8;
        width: int;
        height: int;
    }

    lines := split(copy_string(input), "\n");
    // Remove last line if empty.
    if lines[lines.count - 1].count == 0 lines.count -= 1;

    map: Map;

    for row: lines {
        map_row: [..]u8;
        for cell: cast([]u8) row {
            array_add(*map_row, cell);
        }

        array_add(*map.map, map_row);
    }

    map.width  = map.map[0].count;
    map.height = map.map.count;

    // Identify empty rows and columns.

    empty_rows: [..] int;
    empty_columns: [..] int;

    for y: 0..map.height - 1 {
        empty_row := true;

        for x: 0..map.width - 1 {
            cell := map.map[y][x];
            if cell == #char "#" {
                empty_row = false;
            }
        }

        if empty_row {
            array_add(*empty_rows, y);
        }
    }

    for x: 0..map.width - 1 {
        empty_column := true;

        for y: 0..map.height -1 {
            cell := map.map[y][x];
            if cell == #char "#" {
                empty_column = false;
            }
        }

        if empty_column {
            array_add(*empty_columns, x);
        }
    }

    // Expand the grid.

    expanded_grid: [..][..]u8;
    galaxies: [..][2]int;

    DISTANCE :: 1000000 - 1;

    for y: 0..map.height - 1 {
        expanded_row: [..]u8;

        for x: 0..map.width - 1 {
            cell := map.map[y][x];
            array_add(*expanded_row, cell);

            if array_contains(empty_columns, x) {
                for 0..DISTANCE - 1 {
                    array_add(*expanded_row, #char ".");
                }
            }

            if (cell == #char "#") {
                array_add(*galaxies, .[expanded_row.count - 1, expanded_grid.count]);
            }
        }

        array_add(*expanded_grid, expanded_row);

        if array_contains(empty_rows, y) {
            for 0..DISTANCE - 1 {
                array_add(*expanded_grid, expanded_row);
            }
        }
    }

    sum := 0;
    for i: 0..galaxies.count - 1 {
        for j: i + 1..galaxies.count - 1 {
            distance := abs(galaxies[i][0] - galaxies[j][0]) +
                        abs(galaxies[i][1] - galaxies[j][1]);
            sum += distance;
        }
    }

    return sum;
}
