day08 :: () {
    result_day08_1_example := day08_1_example();
    result_day08_1_input   := day08_1_input();
    result_day08_2_example := day08_2_example();
    result_day08_2_input   := day08_2_input();

    print("day08 part1 example: \t%\n", result_day08_1_example);
    print("day08 part1: \t\t%\n",       result_day08_1_input);
    print("day08 part2 example: \t%\n", result_day08_2_example);
    print("day08 part2: \t\t%\n",       result_day08_2_input);

    assert(result_day08_1_example == 6);
    assert(result_day08_1_input   == 18727);
    assert(result_day08_2_example == 6);
    assert(result_day08_2_input   == 18024643846273);
}

day08_1_example :: () -> int {
    input, success := #run read_entire_file("data/day08_1_example.txt");
    assert(success);

    return day08_1_solve(input);
}

day08_1_input :: () -> int {
    input, success := read_entire_file("data/day08.txt");
    assert(success);

    return day08_1_solve(input);
}

day08_2_example :: () -> int {
    input, success := #run read_entire_file("data/day08_2_example.txt");
    assert(success);

    return day08_2_solve(input);
}

day08_2_input :: () -> int {
    input, success := read_entire_file("data/day08.txt");
    assert(success);

    return day08_2_solve(input);
}

day08_1_solve :: (input: string) -> int {
    Node :: struct {
        left: string;
        right: string;
    }

    steps := read_word(*input);
    dict : Table(string, Node);

    while input.count {
        line := next_line(*input);

        // AAA = (BBB, BBB)
        key := read_key(*line);
        left := read_key(*line);
        right := read_key(*line);

        table_add(*dict, key, Node.{left, right});
    }

    current_key := "AAA";
    i := 0;
    while true {
        step := steps[i % steps.count];

        current_node, success := table_find(*dict, current_key);
        if !success print("=== Error ===\n");

        if step == #char "L" {
            current_key = current_node.left;
        } else if step == #char "R" {
            current_key = current_node.right;
        }

        if current_key == "ZZZ" {
            break;
        }

        i += 1;
    }

    return i + 1;
}

day08_2_solve :: (input: string) -> int {
    Node :: struct {
        left: string;
        right: string;
    }

    steps := read_word(*input);
    dict: Table(string, Node);
    current_keys: [..]string;

    while input.count {
        line := next_line(*input);

        // AAA = (BBB, BBB)
        key := read_key(*line);
        left := read_key(*line);
        right := read_key(*line);

        table_add(*dict, key, Node.{left, right});

        if key[2] == #char "Z" {
            array_add(*current_keys, key);
        }
    }

    find_loop_length :: (key: string, steps: string, dict: Table(string, Node)) -> int {
        current_key := key;
        i := 0;
        while true {
            step := steps[i % steps.count];

            current_node, success := table_find(*dict, current_key);
            if !success print("=== Error ===\n");

            if step == #char "L" {
                current_key = current_node.left;
            } else if step == #char "R" {
                current_key = current_node.right;
            }

            if current_key[2] == #char "Z" {
                break;
            }

            i += 1;
        }

        return i + 1;
    }

    array_min :: (numbers: []int) -> int {
        min := S64_MAX;
        for numbers {
            if it < min min = it;
        }

        return min;
    }

    least_common_denominator :: (numbers: []int) -> int {
        min := array_min(numbers);
        coef := 1;

        while true {
            denominator := min * coef;
            is_divisible := true;

            for number: numbers {
                if denominator % number != 0 {
                    is_divisible = false;
                    break;
                }
            }

            if is_divisible return denominator;

            coef += 1;
        }

        return 0;
    }

    loop_lengths: [..]int;
    for key: current_keys {
        length := find_loop_length(key, steps, dict);
        array_add(*loop_lengths, length);
    }

    result := least_common_denominator(loop_lengths);
    return result;
}

#scope_file

read_key :: (s: *string) -> string {
    word := <<s;
    word.count = 0;

    while s.count && (is_alpha(s.data[0]) || is_digit(s.data[0]))
    {
        word.count += 1;
        advance(s);
    }

    while s.count && !(is_alpha(s.data[0]) || is_digit(s.data[0]))
    {
        advance(s);
    }

    return word;
}
