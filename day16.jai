day16 :: () {
    result_day16_1_example := day16_1_example();
    result_day16_1_input   := day16_1_input();
    result_day16_2_example := day16_2_example();
    result_day16_2_input   := day16_2_input();

    print("day16 part1 example: \t%\n", result_day16_1_example);
    print("day16 part1: \t\t%\n",       result_day16_1_input);
    print("day16 part2 example: \t%\n", result_day16_2_example);
    print("day16 part2: \t\t%\n",       result_day16_2_input);

    assert(result_day16_1_example == 46);
    assert(result_day16_1_input   == 8551);
    assert(result_day16_2_example == 51);
    assert(result_day16_2_input == 8754);
}

day16_1_example :: () -> int {
    input, success := #run read_entire_file("data/day16_1_example.txt");
    assert(success);

    return day16_1_solve(input);
}

day16_1_input :: () -> int {
    input, success := read_entire_file("data/day16.txt");
    assert(success);

    return day16_1_solve(input);
}

day16_2_example :: () -> int {
    input, success := #run read_entire_file("data/day16_1_example.txt");
    assert(success);

    return day16_2_solve(input);
}

day16_2_input :: () -> int {
    input, success := read_entire_file("data/day16.txt");
    assert(success);

    return day16_2_solve(input);
}

day16_1_solve :: (raw_input: string) -> int {
    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    lines := split(input, "\n");

    map: [..][]u8;
    energy_map: [..][]u8;

    for line: lines {
        array_add(*map, cast([]u8) line);

        energy_row: [..]u8;
        array_resize(*energy_row, line.count);
        for energy_row {
            energy_row[it_index] = #char ".";
        }
        array_add(*energy_map, energy_row);
    }

    width := map[0].count;
    height := map.count;

    print_map(map);
    print_map(energy_map);

    beams: [..]Beam;

    beam := Beam.{
        id = next_id(),
        position = .{-1, 0},
        direction = .{1, 0},
    };
    array_add(*beams, beam);

    visited: Table(u32, u8);

    to_add: [..]Beam;
    to_remove: [..]int;

    while beams.count {
        for * beam: beams {
            beam.position += beam.direction;
            // print("beam.position: %\n", beam.position);
            // print("beam.direction: %\n", beam.direction);

            if beam.position.x < 0 || beam.position.x >= width ||
               beam.position.y < 0 || beam.position.y >= height
            {
                array_add(*to_remove, beam.id);
                continue;
            }

            move_hash: u32 = Hash.get_hash(beam.position.x);
            move_hash = Hash.get_hash(beam.position.y, move_hash);
            move_hash = Hash.get_hash(beam.direction.x, move_hash);
            move_hash = Hash.get_hash(beam.direction.y, move_hash);

            if table_contains(*visited, move_hash) {
                array_add(*to_remove, beam.id);
                continue;
            }
            table_set(*visited, move_hash, 0);

            energy_map[beam.position.y][beam.position.x] = #char "#";

            cell := map[beam.position.y][beam.position.x];

            if cell == #char "." {
                continue;
            }

            if cell == #char "|" {
                // Beam is vertical.
                if beam.direction.x == 0 {
                    continue;
                }

                beam.direction = .{0, -1};

                new_beam := Beam.{
                    id = next_id(),
                    position = beam.position,
                    direction = .{0, 1},
                };
                array_add(*to_add, new_beam);

                continue;
            }

            if cell == #char "-" {
                // Beam is horizontal.
                if beam.direction.y == 0 {
                    continue;
                }

                beam.direction = .{-1, 0};

                new_beam := Beam.{
                    id = next_id(),
                    position = beam.position,
                    direction = .{1, 0},
                };
                array_add(*to_add, new_beam);

                continue;
            }

            if cell == #char "\\" {
                // Beam is horizontal.
                if beam.direction.y == 0 {
                    beam.direction.y = beam.direction.x;
                    beam.direction.x = 0;
                } else {
                    beam.direction.x = beam.direction.y;
                    beam.direction.y = 0;
                }

                continue;
            }

            if cell == #char "/" {
                // Beam is horizontal.
                if beam.direction.y == 0 {
                    beam.direction.y = -beam.direction.x;
                    beam.direction.x = 0;
                } else {
                    beam.direction.x = -beam.direction.y;
                    beam.direction.y = 0;
                }

                continue;
            }
        }

        for beam: to_add {
            array_add(*beams, beam);
        }
        for id: to_remove {
            for beam, beam_index: beams {
                if beam.id == id {
                    array_ordered_remove_by_index(*beams, beam_index);
                    break;
                }
            }
        }
        array_reset_keeping_memory(*to_add);
        array_reset_keeping_memory(*to_remove);
    }


    print_map(map);
    print_map(energy_map);

    sum := 0;
    for energy_row: energy_map {
        for cell: energy_row {
            if cell == #char "#" {
                sum += 1;
            }
        }
    }

    return sum;
}

day16_2_solve :: (raw_input: string) -> int {
    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    lines := split(input, "\n");

    map: [..][]u8;

    for line: lines {
        array_add(*map, cast([]u8) line);
    }

    print_map(map);

    width := map[0].count;
    height := map.count;
    sum := 0;

    for i: 0..height - 1 {
        beam := Beam.{
            id = next_id(),
            position = .{-1, i},
            direction = .{1, 0},
        };
        new_sum := compute_beams(beam, map);

        if new_sum > sum sum = new_sum;

        beam = Beam.{
            id = next_id(),
            position = .{width, i},
            direction = .{-1, 0},
        };
        new_sum = compute_beams(beam, map);

        if new_sum > sum sum = new_sum;
    }

    for i: 0..width - 1 {
        beam := Beam.{
            id = next_id(),
            position = .{i, -1},
            direction = .{0, 1},
        };
        new_sum := compute_beams(beam, map);

        if new_sum > sum sum = new_sum;

        beam = Beam.{
            id = next_id(),
            position = .{i, height},
            direction = .{0, -1},
        };
        new_sum = compute_beams(beam, map);

        if new_sum > sum sum = new_sum;
    }

    return sum;
}

compute_beams :: (initial_beam: Beam, map: [][]u8) -> sum: int {
    width := map[0].count;
    height := map.count;

    beams: [..]Beam;
    array_add(*beams, initial_beam);

    energy_map: [..][]u8;
    for row: map {
        energy_row: [..]u8;
        array_resize(*energy_row, row.count);
        for energy_row {
            energy_row[it_index] = #char ".";
        }
        array_add(*energy_map, energy_row);
    }

    visited: Table(u32, u8);

    to_add: [..]Beam;
    to_remove: [..]int;

    while beams.count {
        for * beam: beams {
            beam.position += beam.direction;
            // print("beam.position: %\n", beam.position);
            // print("beam.direction: %\n", beam.direction);

            if beam.position.x < 0 || beam.position.x >= width ||
               beam.position.y < 0 || beam.position.y >= height
            {
                array_add(*to_remove, beam.id);
                continue;
            }

            move_hash: u32 = Hash.get_hash(beam.position.x);
            move_hash = Hash.get_hash(beam.position.y, move_hash);
            move_hash = Hash.get_hash(beam.direction.x, move_hash);
            move_hash = Hash.get_hash(beam.direction.y, move_hash);

            if table_contains(*visited, move_hash) {
                array_add(*to_remove, beam.id);
                continue;
            }
            table_set(*visited, move_hash, 0);

            energy_map[beam.position.y][beam.position.x] = #char "#";

            cell := map[beam.position.y][beam.position.x];

            if cell == #char "." {
                continue;
            }

            if cell == #char "|" {
                // Beam is vertical.
                if beam.direction.x == 0 {
                    continue;
                }

                beam.direction = .{0, -1};

                new_beam := Beam.{
                    id = next_id(),
                    position = beam.position,
                    direction = .{0, 1},
                };
                array_add(*to_add, new_beam);

                continue;
            }

            if cell == #char "-" {
                // Beam is horizontal.
                if beam.direction.y == 0 {
                    continue;
                }

                beam.direction = .{-1, 0};

                new_beam := Beam.{
                    id = next_id(),
                    position = beam.position,
                    direction = .{1, 0},
                };
                array_add(*to_add, new_beam);

                continue;
            }

            if cell == #char "\\" {
                // Beam is horizontal.
                if beam.direction.y == 0 {
                    beam.direction.y = beam.direction.x;
                    beam.direction.x = 0;
                } else {
                    beam.direction.x = beam.direction.y;
                    beam.direction.y = 0;
                }

                continue;
            }

            if cell == #char "/" {
                // Beam is horizontal.
                if beam.direction.y == 0 {
                    beam.direction.y = -beam.direction.x;
                    beam.direction.x = 0;
                } else {
                    beam.direction.x = -beam.direction.y;
                    beam.direction.y = 0;
                }

                continue;
            }
        }

        for beam: to_add {
            array_add(*beams, beam);
        }
        for id: to_remove {
            for beam, beam_index: beams {
                if beam.id == id {
                    array_ordered_remove_by_index(*beams, beam_index);
                    break;
                }
            }
        }
        array_reset_keeping_memory(*to_add);
        array_reset_keeping_memory(*to_remove);
    }

    sum := 0;
    for energy_row: energy_map {
        for cell: energy_row {
            if cell == #char "#" {
                sum += 1;
            }
        }
    }

    // print_map(energy_map);

    array_reset(*beams);
    deinit(*visited);
    for * row: energy_map {
        array_reset(row);
    }
    array_reset(*energy_map);

    return sum;
}

#scope_file

Beam :: struct {
    id: int;
    position: v2s;
    direction: v2s;
}

v2s :: struct {
    x: int;
    y: int;

#place x;
    component: [2] s64 = ---;
}

operator + :: (a: v2s, b: v2s) -> v2s {
    return .{a.x+b.x, a.y+b.y};
}

_current_id := 0;
next_id :: () -> int {
    _current_id += 1;
    return _current_id;
}

print_map :: (map: [][]u8) {
    print("\n");
    for row: map {
        print("%\n", cast(string) row);
    }
    print("\n");
}
