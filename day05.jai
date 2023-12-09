day05 :: () {
    result_day05_1_example := day05_1_example();
    result_day05_1_input   := day05_1_input();
    result_day05_2_example := day05_2_example();
    result_day05_2_input   := day05_2_input();

    print("day05 part1 example: \t%\n", result_day05_1_example);
    print("day05 part1: \t\t%\n",       result_day05_1_input);
    print("day05 part2 example: \t%\n", result_day05_2_example);
    print("day05 part2: \t\t%\n",       result_day05_2_input);

    assert(result_day05_1_example == 35);
    assert(result_day05_1_input   == 84470622);
    assert(result_day05_2_example == 46);
    assert(result_day05_2_input   == 26714516);
}

day05_1_example :: () -> int {
    input, success := #run read_entire_file("data/day05_1_example.txt");
    assert(success);

    return day05_1_solve(input);
}

day05_1_input :: () -> int {
    input, success := read_entire_file("data/day05.txt");
    assert(success);

    return day05_1_solve(input);
}

day05_2_example :: () -> int {
    input, success := #run read_entire_file("data/day05_1_example.txt");
    assert(success);

    return day05_2_solve(input);
}

day05_2_input :: () -> int {
    input, success := read_entire_file("data/day05.txt");
    assert(success);

    return day05_2_solve(input);
}

day05_1_solve :: (input: string) -> int {
    Range :: struct {
        start : int;
        end   : int;
        range : int;
    }

    Mapper :: struct {
        ranges: [..] Range;
    }

    seeds: [..] int;

    line := next_line(*input);
    advance(*line, 7); // Skip 'seeds: '.

    // Parse seeds.

    while line.count {
        seed := read_s64(*line);
        array_add(*seeds, seed);
    }

    // Parse maps.

    mapper: Mapper;
    maps: [..] Mapper;

    while input.count {
        line := next_line(*input);

        if line.count == 0 {
            next_line(*input);

            if mapper.ranges.count {
                array_add(*maps, mapper);
            }

            new_mapper: Mapper;
            mapper = new_mapper;

            continue;
        }

        range: Range;
        scan2(line, "% % %", *range.end, *range.start, *range.range);

        array_add(*mapper.ranges, range);
    }

    // Get locations from seeds and maps.

    get_value :: (mapper: Mapper, value: int) -> int {
        for range: mapper.ranges {
            if value >= range.start && value < range.start + range.range {
                offset := value - range.start;
                return range.end + offset;
            }
        }

        return value;
    }

    result := S64_MAX;

    for seed: seeds {
        value := seed;

        for mapper: maps {
            value = get_value(mapper, value);
        }

        if value < result result = value;
    }

    return result;
}

day05_2_solve :: (input: string) -> int {
    Range :: struct {
        start : int;
        end   : int;
        range : int;
    }

    Mapper :: struct {
        ranges: [..] Range;
    }

    SeedRange :: struct {
        start: int;
        length: int;
    }

    seed_ranges: [..] SeedRange;

    line := next_line(*input);
    advance(*line, 7); // Skip 'seeds: '.

    // Parse seed ranges.

    while line.count {
        seed_range: SeedRange;
        seed_range.start = read_s64(*line);
        seed_range.length = read_s64(*line);
        array_add(*seed_ranges, seed_range);
    }

    // Parse maps.

    mapper: Mapper;
    maps: [..] Mapper;

    while input.count {
        line := next_line(*input);

        if line.count == 0 {
            next_line(*input);

            if mapper.ranges.count {
                array_add(*maps, mapper);
            }

            new_mapper: Mapper;
            mapper = new_mapper;

            continue;
        }

        range: Range;
        scan2(line, "% % %", *range.end, *range.start, *range.range);

        array_add(*mapper.ranges, range);
    }

    // Start with the location, map from the end and check if the seed exists.

    get_value_reverse :: (mapper: Mapper, value: int) -> int {
        for range: mapper.ranges {
            if value >= range.end && value < range.end + range.range {
                offset := value - range.end;
                return range.start + offset;
            }
        }

        return value;
    }

    for location: 0..S64_MAX {
        value := location;
        for < mapper: maps {
            value = get_value_reverse(mapper, value);
        }


        for seed_range: seed_ranges {
            start := seed_range.start;
            end := start + seed_range.length - 1;

            if value >= start && value <= end {
                return location;
            }
        }
    }

    return 0;
}

