day01 :: () {
    print("day01 part1 example: \t%\n", day01_1_example());
    print("day01 part1: \t\t%\n",       day01_1_input());
    print("day01 part2 example: \t%\n", day01_2_example());
    print("day01 part2: \t\t%\n",       day01_2_input());

    // day01 part1 example:    142
    // day01 part1:            55971
    // day01 part2 example:    281
    // day01 part2:            54719
}

day01_1_example :: () -> int {
    input, success := read_entire_file("data/day01_1_example.txt");
    assert(success);

    return day01_1_solve(input);
}

day01_1_input :: () -> int {
    input, success := read_entire_file("data/day01.txt");
    assert(success);

    return day01_1_solve(input);
}

day01_2_example :: () -> int {
    input, success := read_entire_file("data/day01_2_example.txt");
    assert(success);

    return day01_2_solve(input);
}

day01_2_input :: () -> int {
    input, success := read_entire_file("data/day01.txt");
    assert(success);

    return day01_2_solve(input);
}

day01_1_solve :: (input: string) -> int {
    lines := split(input, "\n");

    total := 0;
    first_digit: u8 = 0;
    last_digit: u8 = 0;

    for line: lines {
        if line.count == 0 {
            continue;
        }

        first_digit = 0;
        last_digit = 0;

        line_array := cast([]u8) line;
        for c: line_array {
            if c >= #char "0" && c <= #char "9" {
                if first_digit == 0 {
                    first_digit = c - #char "0";
                }
                last_digit = c - #char "0";
            }
        }

        if first_digit == 0 {
            continue;
        }

        total += first_digit * 10 + last_digit;
    }

    return total;
}

day01_2_solve :: (input: string) -> int {
    get_next_char_digit :: (str: *string) -> u8 {
        assert(str.count > 0);

        result: u8 = 0;

        while (str.count > 0) {
            c := (cast([]u8) <<str)[0];

            if c >= #char "0" && c <= #char "9" {
                result = c;
            } else if begins_with(<<str, "zero") {
                result = #char "0";
            } else if begins_with(<<str, "one") {
                result = #char "1";
            } else if begins_with(<<str, "two") {
                result = #char "2";
            } else if begins_with(<<str, "three") {
                result = #char "3";
            } else if begins_with(<<str, "four") {
                result = #char "4";
            } else if begins_with(<<str, "five") {
                result = #char "5";
            } else if begins_with(<<str, "six") {
                result = #char "6";
            } else if begins_with(<<str, "seven") {
                result = #char "7";
            } else if begins_with(<<str, "eight") {
                result = #char "8";
            } else if begins_with(<<str, "nine") {
                result = #char "9";
            }

            str.data += 1;
            str.count -= 1;

            if result != 0 {
                return result;
            }
        }

        return 0;
    }

    lines := split(input, "\n");

    total := 0;
    first_digit: u8 = 0;
    last_digit: u8 = 0;

    for line: lines {
        if line.count == 0 {
            continue;
        }

        first_digit = 0;
        last_digit = 0;

        line_cursor := line;
        while line_cursor.count > 0 {
            c: u8 = get_next_char_digit(*line_cursor);

            if c == 0 {
                break;
            }

            if first_digit == 0 {
                first_digit = c - #char "0";
            }
            last_digit = c - #char "0";
        }

        if first_digit == 0 {
            continue;
        }

        total += first_digit * 10 + last_digit;
    }

    return total;
}

