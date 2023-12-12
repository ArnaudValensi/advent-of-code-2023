day12 :: () {
    result_day12_1_example := day12_1_example();
    result_day12_1_input   := day12_1_input();
    result_day12_2_example := day12_2_example();
    result_day12_2_input   := day12_2_input();

    print("day12 part1 example: \t%\n", result_day12_1_example);
    print("day12 part1: \t\t%\n",       result_day12_1_input);
    print("day12 part2 example: \t%\n", result_day12_2_example);
    print("day12 part2: \t\t%\n",       result_day12_2_input);

    assert(result_day12_1_example == 21);
    assert(result_day12_1_input   == 7922);
    assert(result_day12_2_example == 525152);
    assert(result_day12_2_input == 18093821750095);
}

day12_1_example :: () -> int {
    input, success := #run read_entire_file("data/day12_1_example.txt");
    assert(success);

    return day12_1_solve(input);
}

day12_1_input :: () -> int {
    input, success := read_entire_file("data/day12.txt");
    assert(success);

    return day12_1_solve(input);
}

day12_2_example :: () -> int {
    input, success := #run read_entire_file("data/day12_1_example.txt");
    assert(success);

    return day12_2_solve(input);
}

day12_2_input :: () -> int {
    input, success := read_entire_file("data/day12.txt");
    assert(success);

    return day12_2_solve(input);
}

day12_1_solve :: (input: string) -> int {
    lines := split(copy_string(input), "\n");
    // Remove last line if empty.
    if lines[lines.count - 1].count == 0 lines.count -= 1;

    sum := 0;

    for line: lines {
        springs := read_word(*line);
        groups: [..] int;

        while line.count {
            array_add(*groups, read_s64(*line));
            if line.count advance(*line);
        }

        num_arrangements := find_arrangements(springs, groups);
        sum += num_arrangements;
    }

    return sum;
}

day12_2_solve :: (input: string) -> int {
    lines := split(copy_string(input), "\n");
    // Remove last line if empty.
    if lines[lines.count - 1].count == 0 lines.count -= 1;

    sum := 0;

    for line: lines {
        springs := read_word(*line);
        groups: [..] int;

        while line.count {
            array_add(*groups, read_s64(*line));
            if line.count advance(*line);
        }

        for i: 0..groups.count * 4 - 1 {
            array_add(*groups, groups[i]);
        }

        builder: String_Builder;
        for 0..4 {
            append(*builder, springs);
            if it != 4 {
                append(*builder, "?");
            }
        }
        springs = builder_to_string(*builder);

        table_reset(*_cache);
        num_arrangements := find_arrangements(springs, groups);

        sum += num_arrangements;
    }

    return sum;
}

#scope_file

_cache: Table(u32, int);

find_arrangements :: (springs: string, groups: []int) -> int {
    if springs.count == 0 {
        return ifx groups.count == 0 1 else 0;
    }

    if groups.count == 0 {
        return ifx contains(springs, "#") 0 else 1;
    }

    cache_key := hash(springs, groups);
    value, has_value := table_find(*_cache, cache_key);
    if has_value return value;

    result := 0;

    if springs[0] == #char "." || springs[0] == #char "?" {
        result += find_arrangements(advance2(springs), groups);
    }

    if springs[0] == #char "#" || springs[0] == #char "?" {
        if groups[0] <= springs.count &&
            !contains(springs, ".", length=groups[0]) &&
            (groups[0] == springs.count || springs[groups[0]] != #char "#")
        {
            new_groups := groups;
            new_groups.count -= 1;
            new_groups.data += 1;

            new_springs := advance2(springs, groups[0] + 1);
            result += find_arrangements(new_springs, new_groups);
        }
    }

    table_set(*_cache, cache_key, result);

    return result;
}

hash :: (springs: string, groups: []int) -> u32 {
    h := Hash.get_hash(springs);
    return Hash.get_hash(groups, h);
}

// This version allow to have empty strings.
advance2 :: (s: string, amount: s64 = 1) -> string #must {
    t: string = ---;
    t.count = s.count - amount;
    t.data  = s.data  + amount;
    return t;
}

contains :: (s: string, substring: string, length: int) -> bool {
    new_string := s;
    new_string.count = length;
    return find_index_from_left(new_string, substring) != -1;
}
