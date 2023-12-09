day06 :: () {
    result_day06_1_example := day06_1_example();
    result_day06_1_input   := day06_1_input();
    result_day06_2_example := day06_2_example();
    result_day06_2_input   := day06_2_input();

    print("day06 part1 example: \t%\n", result_day06_1_example);
    print("day06 part1: \t\t%\n",       result_day06_1_input);
    print("day06 part2 example: \t%\n", result_day06_2_example);
    print("day06 part2: \t\t%\n",       result_day06_2_input);

    assert(result_day06_1_example == 288);
    assert(result_day06_1_input   == 32076);
    assert(result_day06_2_example == 71503);
    assert(result_day06_2_input   == 34278221);
}

day06_1_example :: () -> int {
    races: [][]int = .[.[7, 9], .[15, 40], .[30, 200]];
    return day06_1_solve(races);
}

day06_1_input :: () -> int {
    races: [][]int = .[.[44, 208], .[80, 1581], .[65, 1050], .[72, 1102]];
    return day06_1_solve(races);
}

day06_2_example :: () -> int {
    time := 71530;
    dist := 940200;

    return winning_move(time, dist);
}

day06_2_input :: () -> int {
    time := 44806572;
    dist := 208158110501102;

    return winning_move(time, dist);
}

winning_move :: (time: s64, dist: s64) -> s64 {
    for i: 1..time-1 {
        velocity := i * (time - i);
        if velocity > dist {
            return time - (i * 2 - 1);
        }
    }

    return 0;
}

day06_1_solve :: (races: [][]int) -> int {
    result := 1;

    for race: races {
        time := race[0];
        dist := race[1];
        result *= winning_move(time, dist);
    }

    return result;
}
