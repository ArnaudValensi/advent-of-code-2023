day09 :: () {
    result_day09_1_example := day09_1_example();
    result_day09_1_input   := day09_1_input();
    result_day09_2_example := day09_2_example();
    result_day09_2_input   := day09_2_input();

    print("day09 part1 example: \t%\n", result_day09_1_example);
    print("day09 part1: \t\t%\n",       result_day09_1_input);
    print("day09 part2 example: \t%\n", result_day09_2_example);
    print("day09 part2: \t\t%\n",       result_day09_2_input);

    assert(result_day09_1_example == 114);
    assert(result_day09_1_input   == 1882395907);
    assert(result_day09_2_example == 2);
    assert(result_day09_2_input   == 1005);
}

day09_1_example :: () -> int {
    input, success := #run read_entire_file("data/day09_1_example.txt");
    assert(success);

    return day09_1_solve(input);
}

day09_1_input :: () -> int {
    input, success := read_entire_file("data/day09.txt");
    assert(success);

    return day09_1_solve(input);
}

day09_2_example :: () -> int {
    input, success := #run read_entire_file("data/day09_1_example.txt");
    assert(success);

    return day09_2_solve(input);
}

day09_2_input :: () -> int {
    input, success := read_entire_file("data/day09.txt");
    assert(success);

    return day09_2_solve(input);
}

day09_1_solve :: (input: string) -> int {
    lines := split(input, "\n");
    // Remove last line if empty.
    if lines[lines.count - 1].count == 0 lines.count -= 1;

    is_all_zero :: (numbers: []int) -> bool {
        for numbers {
            if it != 0 return false;
        }

        return true;
    }

    compute_below :: (numbers: []int) -> int {
        if is_all_zero(numbers) {
            return 0;
        }

        sub_numbers: [..]int;
        for i: 0..(numbers.count - 2) {
            array_add(*sub_numbers, numbers[i + 1] - numbers[i]);
        }

        return numbers[numbers.count -1] + compute_below(sub_numbers);
    }

    sum := 0;

    for line: lines {
        numbers: [..]int;

        while line.count {
            current_number := read_s64(*line);
            array_add(*numbers, current_number);
        }

        result := compute_below(numbers);
        sum += result;
    }

    return sum;
}

day09_2_solve :: (input: string) -> int {
    lines := split(input, "\n");
    // Remove last line if empty.
    if lines[lines.count - 1].count == 0 lines.count -= 1;

    is_all_zero :: (numbers: []int) -> bool {
        for numbers {
            if it != 0 return false;
        }

        return true;
    }

    compute_below :: (numbers: []int) -> int {
        if is_all_zero(numbers) {
            return 0;
        }

        sub_numbers: [..]int;
        for i: 0..(numbers.count - 2) {
            array_add(*sub_numbers, numbers[i + 1] - numbers[i]);
        }

        // Only this has changed from the part 1.
        return numbers[0] - compute_below(sub_numbers);
    }

    sum := 0;

    for line: lines {
        numbers: [..]int;

        while line.count {
            current_number := read_s64(*line);
            array_add(*numbers, current_number);
        }

        result := compute_below(numbers);
        sum += result;
    }

    return sum;
}
