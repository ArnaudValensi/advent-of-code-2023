day07 :: () {
    result_day07_1_example := day07_1_example();
    result_day07_1_input   := day07_1_input();
    result_day07_2_example := day07_2_example();
    result_day07_2_input   := day07_2_input();

    print("day07 part1 example: \t%\n", result_day07_1_example);
    print("day07 part1: \t\t%\n",       result_day07_1_input);
    print("day07 part2 example: \t%\n", result_day07_2_example);
    print("day07 part2: \t\t%\n",       result_day07_2_input);

    assert(result_day07_1_example == 6440);
    assert(result_day07_1_input   == 247823654);
    assert(result_day07_2_example == 5905);
    assert(result_day07_2_input   == 245461700);
}

day07_1_example :: () -> int {
    input, success := #run read_entire_file("data/day07_1_example.txt");
    assert(success);

    return day07_1_solve(input);
}

day07_1_input :: () -> int {
    input, success := read_entire_file("data/day07.txt");
    assert(success);

    return day07_1_solve(input);
}

day07_2_example :: () -> int {
    input, success := #run read_entire_file("data/day07_1_example.txt");
    assert(success);

    return day07_2_solve(input);
}

day07_2_input :: () -> int {
    input, success := read_entire_file("data/day07.txt");
    assert(success);

    return day07_2_solve(input);
}

cards: []u8 = cast([]u8) "23456789TJQKA";

day07_1_solve :: (input: string) -> int {
    Item :: struct {
        hand  : string;
        bid   : int;
        score : int;
    }

    compute_score :: (hand: string) -> score: int {
        count_table: [13]int;

        for c: cast([]u8) hand {
            _, index := array_find(cards, c);
            count_table[index] += 1;
        }

        quick_sort(count_table, (a) => -a);

        if count_table[0] == 5 {
            return 6;
        } else if count_table[0] == 4 &&
                  count_table[1] == 1
        {
            return 5;
        } else if count_table[0] == 3 &&
                  count_table[1] == 2
        {
            return 4;
        } else if count_table[0] == 3 &&
                  count_table[1] == 1 &&
                  count_table[2] == 1
        {
            return 3;
        } else if count_table[0] == 2 &&
                  count_table[1] == 2 &&
                  count_table[2] == 1
        {
            return 2;
        } else if count_table[0] == 2 &&
                  count_table[1] == 1 &&
                  count_table[2] == 1 &&
                  count_table[3] == 1
        {
            return 1;
        } else if count_table[0] == 1 &&
                  count_table[1] == 1 &&
                  count_table[2] == 1 &&
                  count_table[3] == 1 &&
                  count_table[4] == 1
        {
            return 0;
        }

        print("== ERROR ==\n");
        return 0;
    }

    lines := split(input, "\n");
    items: [..] Item;

    for line: lines {
        // Skip last line if empty.
        if !line.count break;

        item: Item;
        item.hand = read_word(*line);
        item.bid = read_s64(*line);
        item.score = compute_score(item.hand);

        array_add(*items, item);
    }

    sort_items :: (a: Item, b: Item) -> s64 {
        if a.score == b.score {
            for i: 0..4 {
                if a.hand[i] == b.hand[i] continue;

                _, index_a := array_find(cards, a.hand[i]);
                _, index_b := array_find(cards, b.hand[i]);

                return index_a - index_b;
            }

            return 0;
        }
        return a.score - b.score;
    }

    quick_sort(items, sort_items);

    result := 0;
    for item, i: items {
        result += (i + 1) * item.bid;
    }

    return result;
}

cards2: []u8 = cast([]u8) "J23456789TJQKA";

day07_2_solve :: (input: string) -> int {
    Item :: struct {
        hand  : string;
        bid   : int;
        score : int;
    }

    compute_score :: (hand: string) -> score: int {
        count_table: [13]int;
        jokers := 0;

        for c: cast([]u8) hand {
            if c == #char "J" {
                jokers += 1;
                continue;
            }
            _, index := array_find(cards, c);
            count_table[index] += 1;
        }

        quick_sort(count_table, (a) => -a);

        for 0..jokers - 1 {
            count_table[0] += 1;
        }

        if count_table[0] == 5 {
            return 6;
        } else if count_table[0] == 4 &&
                  count_table[1] == 1
        {
            return 5;
        } else if count_table[0] == 3 &&
                  count_table[1] == 2
        {
            return 4;
        } else if count_table[0] == 3 &&
                  count_table[1] == 1 &&
                  count_table[2] == 1
        {
            return 3;
        } else if count_table[0] == 2 &&
                  count_table[1] == 2 &&
                  count_table[2] == 1
        {
            return 2;
        } else if count_table[0] == 2 &&
                  count_table[1] == 1 &&
                  count_table[2] == 1 &&
                  count_table[3] == 1
        {
            return 1;
        } else if count_table[0] == 1 &&
                  count_table[1] == 1 &&
                  count_table[2] == 1 &&
                  count_table[3] == 1 &&
                  count_table[4] == 1
        {
            return 0;
        }

        print("== ERROR ==\n");
        return 0;
    }

    lines := split(input, "\n");
    items: [..] Item;

    for line: lines {
        // Skip last line if empty.
        if !line.count break;

        item: Item;
        item.hand = read_word(*line);
        item.bid = read_s64(*line);
        item.score = compute_score(item.hand);

        array_add(*items, item);
    }

    sort_items :: (a: Item, b: Item) -> s64 {
        if a.score == b.score {
            for i: 0..4 {
                if a.hand[i] == b.hand[i] continue;

                _, index_a := array_find(cards2, a.hand[i]);
                _, index_b := array_find(cards2, b.hand[i]);

                return index_a - index_b;
            }

            return 0;
        }
        return a.score - b.score;
    }

    quick_sort(items, sort_items);

    result := 0;
    for item, i: items {
        result += (i + 1) * item.bid;
    }

    return result;
}
