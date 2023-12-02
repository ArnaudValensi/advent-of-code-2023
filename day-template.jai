day03 :: () {
    print("day03 part1 example: \t%\n", day03_1_example());
    print("day03 part1: \t\t%\n",       day03_1_input());
    print("day03 part2 example: \t%\n", day03_2_example());
    print("day03 part2: \t\t%\n",       day03_2_input());

    // day03 part1 example:    8
    // day03 part1:            1853
    // day03 part2 example:    2286
    // day03 part2:            72706
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
    return 0;
}

day03_2_solve :: (input: string) -> int {
    return 0;
}
