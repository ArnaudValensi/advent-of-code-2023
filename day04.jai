day04 :: () {
    print("day04 part1 example: \t%\n", day04_1_example());
    print("day04 part1: \t\t%\n",       day04_1_input());
    print("day04 part2 example: \t%\n", day04_2_example());
    print("day04 part2: \t\t%\n",       day04_2_input());

    // day04 part1 example:    13
    // day04 part1:            27845
    // day04 part2 example:    30
    // day04 part2:            9496801
}

day04_1_example :: () -> int {
    input, success := #run read_entire_file("data/day04_1_example.txt");
    assert(success);

    return day04_1_solve(input);
}

day04_1_input :: () -> int {
    input, success := read_entire_file("data/day04.txt");
    assert(success);

    return day04_1_solve(input);
}

day04_2_example :: () -> int {
    input, success := #run read_entire_file("data/day04_1_example.txt");
    assert(success);

    return day04_2_solve(input);
}

day04_2_input :: () -> int {
    input, success := read_entire_file("data/day04.txt");
    assert(success);

    return day04_2_solve(input);
}

day04_1_solve :: (input: string) -> int {
    lines := split(input, "\n");

    winning_numbers: [..] int;
    my_numbers: [..] int;

    result := 0;

    for line: lines {
        // Remove last line if empty.
        if !line.count break;

        advance(*line, 4); // Skip 'Card'.
        skip_whitespace(*line);
        card_id := read_s64(*line);
        skip_whitespace(*line);
        advance(*line, 1); // Skip ':'.
        skip_whitespace(*line);

        while line[0] != #char "|" {
            next_number := read_s64(*line);
            array_add(*winning_numbers, next_number);
        }

        advance(*line, 1); // Skip '|'.
        skip_whitespace(*line);

        while line.count {
            next_number := read_s64(*line);
            array_add(*my_numbers, next_number);
        }

        points := 0;
        for number: my_numbers {
            if array_find(winning_numbers, number) {
                if points == 0 {
                    points = 1;
                } else {
                    points *= 2;
                }
            }
        }

        result += points;
        array_reset_keeping_memory(*winning_numbers);
        array_reset_keeping_memory(*my_numbers);
    }

    return result;
}

day04_2_solve :: (input: string) -> int {
    lines := split(input, "\n");

    winning_numbers: [..] int;
    my_numbers: [..] int;

    scores: Table(int, int);

    for line: lines {
        // Remove last line if empty.
        if !line.count break;

        advance(*line, 4); // Skip 'Card'.
        skip_whitespace(*line);
        card_id := read_s64(*line);
        skip_whitespace(*line);
        advance(*line, 1); // Skip ':'.
        skip_whitespace(*line);

        while line[0] != #char "|" {
            next_number := read_s64(*line);
            array_add(*winning_numbers, next_number);
        }

        advance(*line, 1); // Skip '|'.
        skip_whitespace(*line);

        while line.count {
            next_number := read_s64(*line);
            array_add(*my_numbers, next_number);
        }

        wins := 0;
        for number: my_numbers {
            if array_find(winning_numbers, number) {
                wins += 1;
            }
        }

        current_copies, newly_added := find_or_add(*scores, card_id);
        if newly_added {
            << current_copies = 1;
        }

        for 1..wins {
            id := card_id + it;
            number := table_find_pointer(*scores, id);
            if number == null {
                table_add(*scores, id, 1 + << current_copies);
            } else {
                << number += << current_copies;
            }
        }

        array_reset_keeping_memory(*winning_numbers);
        array_reset_keeping_memory(*my_numbers);
    }

    result := 0;

    for scores {
        copies := it;
        result += copies;
    }

    return result;
}

