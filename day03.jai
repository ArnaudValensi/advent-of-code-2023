day03 :: () {
    print("day03 part1 example: \t%\n", day03_1_example());
    print("day03 part1: \t\t%\n",       day03_1_input());
    print("day03 part2 example: \t%\n", day03_2_example());
    print("day03 part2: \t\t%\n",       day03_2_input());

    // day03 part1 example:    4361
    // day03 part1:            546312
    // day03 part2 example:    467835
    // day03 part2:            87449461
}

day03_1_example :: () -> int {
    input, success := #run read_entire_file("data/day03_1_example.txt");
    assert(success);

    return day03_1_solve(input);
}

day03_1_input :: () -> int {
    input, success := read_entire_file("data/day03.txt");
    assert(success);

    return day03_1_solve(input);
}

day03_2_example :: () -> int {
    input, success := #run read_entire_file("data/day03_1_example.txt");
    assert(success);

    return day03_2_solve(input);
}

day03_2_input :: () -> int {
    input, success := read_entire_file("data/day03.txt");
    assert(success);

    return day03_2_solve(input);
}

day03_1_solve :: (input: string) -> int {
    get_at :: (schema: [] string, x: int, y: int) -> u8 {
        return schema[y].data[x];
    }

    has_special_char_around :: (schema: [] string, x: int, y: int, max_x: int, max_y: int) -> bool {
        for i: x-1..x+1 {
            for j: y-1..y+1 {
                if i < 0 || j < 0 || i >= max_x || j >= max_y {
                    continue;
                }

                c := get_at(schema, i, j);
                if !is_digit(c) && c != #char "." {
                    return true;
                }
            }
        }

        return false;
    }

    schema := split(input, "\n");

    // Remove last line if empty.
    if schema[schema.count - 1].count == 0 schema.count -= 1;

    max_x := schema[0].count;
    max_y := schema.count;

    sum := 0;
    current_number := 0;
    is_valid_number := false;

    for y: 0..max_y-1 {
        for x: 0..max_x-1 {
            c := get_at(schema, x, y);

            if is_digit(c) {
                current_number *= 10;
                current_number += c - #char "0";

                if has_special_char_around(schema, x, y, max_x, max_y) {
                    is_valid_number = true;
                }
            } else {
                if current_number != 0 {
                    if is_valid_number {
                        sum += current_number;
                    }

                    current_number = 0;
                    is_valid_number = false;
                }
            }
        }

        if current_number != 0 {
            if is_valid_number {
                sum += current_number;
            }

            current_number = 0;
            is_valid_number = false;
        }
    }

    return sum;
}

gear_positions: Table(
    Position,
    u8,
    given_hash_function=hash_position,
    given_compare_function=compare_position
);

day03_2_solve :: (input: string) -> int {
    get_at :: (schema: [] string, x: int, y: int) -> u8 {
        return schema[y].data[x];
    }

    get_gear_positions_around :: (schema: [] string, x: int, y: int, max_x: int, max_y: int) {
        for i: x-1..x+1 {
            for j: y-1..y+1 {
                if i < 0 || j < 0 || i >= max_x || j >= max_y {
                    continue;
                }

                c := get_at(schema, i, j);
                if c == #char "*" {
                    table_set(*gear_positions, Position.{i, j}, 0);
                }
            }
        }
    }

    schema := split(input, "\n");

    // Remove last line if empty.
    if schema[schema.count - 1].count == 0 schema.count -= 1;

    max_x := schema[0].count;
    max_y := schema.count;

    current_number := 0;

    gear_numbers_map: Table(
        Position,
        [..] int,
        given_hash_function=hash_position,
        given_compare_function=compare_position
    );

    for y: 0..max_y-1 {
        for x: 0..max_x-1 {
            c := get_at(schema, x, y);

            if is_digit(c) {
                current_number *= 10;
                current_number += c - #char "0";

                // This fills up gear_positions;
                get_gear_positions_around(schema, x, y, max_x, max_y);
            } else {
                if current_number != 0 {
                    for gear_positions {
                        gear_position := it_index;
                        numbers := table_find_pointer(*gear_numbers_map, gear_position);
                        if numbers == null {
                            new_numbers: [..] int;
                            array_add(*new_numbers, current_number);
                            table_add(*gear_numbers_map, gear_position, new_numbers);
                        } else {
                            array_add(numbers, current_number);
                        }
                    }

                    current_number = 0;
                    table_reset(*gear_positions);
                }
            }
        }

        if current_number != 0 {
            for gear_positions {
                gear_position := it_index;
                numbers := table_find_pointer(*gear_numbers_map, gear_position);
                if numbers == null {
                    new_numbers: [..] int;
                    array_add(*new_numbers, current_number);
                    table_add(*gear_numbers_map, gear_position, new_numbers);
                } else {
                    array_add(numbers, current_number);
                }
            }

            current_number = 0;
            table_reset(*gear_positions);
        }
    }

    sum := 0;
    for gear_numbers_map {
        position := it_index;
        values := it;

        if values.count == 2 {
            sum += values[0] * values[1];
        }
    }

    return sum;
}

Position :: struct {
    x: int;
    y: int;
}

compare_position :: (a: Position, b: Position) -> bool {
    return a.x == b.x && a.y == b.y;
}

hash_position :: (v: Position) -> u32 {
    return cast,trunc(u32) Hash.fnv1a_hash(*v, size_of(Position));
}
