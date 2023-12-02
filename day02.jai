day02 :: () {
    print("day02 part1 example: \t%\n", day02_1_example());
    print("day02 part1: \t\t%\n",       day02_1_input());
    print("day02 part2 example: \t%\n", day02_2_example());
    print("day02 part2: \t\t%\n",       day02_2_input());

    // day02 part1 example:    8
    // day02 part1:            1853
    // day02 part2 example:    2286
    // day02 part2:            72706
}

day02_1_example :: () -> int {
    input, success := #run read_entire_file("data/day02_1_example.txt");
    assert(success);

    return day02_1_solve(input);
}

day02_1_input :: () -> int {
    input, success := read_entire_file("data/day02.txt");
    assert(success);

    return day02_1_solve(input);
}

day02_2_example :: () -> int {
    input, success := #run read_entire_file("data/day02_1_example.txt");
    assert(success);

    return day02_2_solve(input);
}

day02_2_input :: () -> int {
    input, success := read_entire_file("data/day02.txt");
    assert(success);

    return day02_2_solve(input);
}

day02_1_solve :: (input: string) -> int {
    is_separator :: (c: u8) -> bool {
        return c == #char "," || c == #char ";" || c == #char " ";
    }

    total :=  0;
    lines := split(input, "\n");

    for line: lines {
        if !line.count break;
        advance(*line, 5); // Skip 'Game '.
        game_id := read_s64(*line);
        advance(*line, 2); // Skip ': '.

        is_valid := true;

        while line.count && line.data[0] != #char "\n" {
            number := read_s64(*line);
            color := read_alpha_word(*line);

            if color == "red" && number > 12   ||
               color == "green" && number > 13 ||
               color == "blue" && number > 14
            {
                is_valid = false;
                break;
            }

            // Eat ",", ";", " ".
            while line.count && is_separator(line.data[0]) {
                advance(*line, 1);
            }
        }

        if is_valid total += game_id;
    }

    return total;
}

day02_2_solve :: (input: string) -> int {
    is_separator :: (c: u8) -> bool {
        return c == #char "," || c == #char ";" || c == #char " ";
    }

    total :=  0;
    lines := split(input, "\n");

    for line: lines {
        if !line.count break;

        max_red := 0;
        max_green := 0;
        max_blue := 0;

        advance(*line, 5); // Skip 'Game '.
        game_id := read_s64(*line);
        advance(*line, 2); // Skip ': '.

        while line.count && line.data[0] != #char "\n" {
            number := read_s64(*line);
            color := read_alpha_word(*line);

            if color == "red" && number > max_red max_red = number;
            if color == "green" && number > max_green max_green = number;
            if color == "blue" && number > max_blue max_blue = number;

            // Eat ",", ";", " ".
            while line.count && is_separator(line.data[0]) {
                advance(*line, 1);
            }
        }

        total += max_red * max_green * max_blue;
    }

    return total;
}

#scope_file

read_alpha_word :: (s: *string) -> string {
    word := <<s;
    word.count = 0;

    while s.count && is_alpha(s.data[0])
    {
        word.count += 1;
        advance(s);
    }

    return word;
}
