day15 :: () {
    result_day15_1_example := day15_1_example();
    result_day15_1_input   := day15_1_input();
    result_day15_2_example := day15_2_example();
    result_day15_2_input   := day15_2_input();

    print("day15 part1 example: \t%\n", result_day15_1_example);
    print("day15 part1: \t\t%\n",       result_day15_1_input);
    print("day15 part2 example: \t%\n", result_day15_2_example);
    print("day15 part2: \t\t%\n",       result_day15_2_input);

    assert(result_day15_1_example == 1320);
    assert(result_day15_1_input   == 494980);
    assert(result_day15_2_example == 145);
    assert(result_day15_2_input == 247933);
}

day15_1_example :: () -> int {
    input := "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7";

    return day15_1_solve(input);
}

day15_1_input :: () -> int {
    input, success := read_entire_file("data/day15.txt");
    assert(success);

    return day15_1_solve(input);
}

day15_2_example :: () -> int {
    input := "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7";

    return day15_2_solve(input);
}

day15_2_input :: () -> int {
    input, success := read_entire_file("data/day15.txt");
    assert(success);

    return day15_2_solve(input);
}

day15_1_solve :: (raw_input: string) -> int {
    hash :: (str: string) -> int {
        result := 0;
        for c: cast([]u8) str {
            result = (result + c) * 17 % 256;
        }

        return result;
    }

    assert(hash("HASH") == 52);

    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    sum := 0;

    while input.count {
        item := read_next_split(*input, #char ",");

        h := hash(item);
        sum += h;
    }

    return sum;
}

day15_2_solve :: (raw_input: string) -> int {
    Instruction :: struct {
        label: string;
        hash: int;
        is_insert: bool;
        focal_length: int;
    }

    Slot :: struct {
        label: string;
        focal_length: int;
    }

    hash :: (str: string) -> int {
        result := 0;
        for c: cast([]u8) str {
            result = (result + c) * 17 % 256;
        }

        return result;
    }
    assert(hash("HASH") == 52);

    next_instruction :: (item: *string) -> Instruction {
        instruction: Instruction;
        instruction.label = read_alpha_word(item);
        instruction.hash = hash(instruction.label);

        if item.data[0] == #char "=" {
            instruction.is_insert = true;
            advance(item);
            instruction.focal_length = read_s64(item);
        } else {
            instruction.is_insert = false;
        }

        return instruction;
    }

    find_slot_index :: (slots: [] Slot, label: string) -> int {
        for slot: slots {
            if slot.label == label {
                return it_index;
            }
        }

        return -1;
    }

    input := copy_string(raw_input);
    if input[input.count - 1] == #char "\n" input.count -= 1;

    boxes: [256][..] Slot;

    while input.count {
        item := read_next_split(*input, #char ",");
        inst := next_instruction(*item);

        if inst.is_insert {
            slot_index := find_slot_index(boxes[inst.hash], inst.label);

            if slot_index == -1 {
                array_add(*boxes[inst.hash], Slot.{inst.label, inst.focal_length});
                continue;
            }

            boxes[inst.hash][slot_index].focal_length = inst.focal_length;
        } else {
            slot_index := find_slot_index(boxes[inst.hash], inst.label);
            if slot_index != -1 {
                array_ordered_remove_by_index(*boxes[inst.hash], slot_index);
            }
        }
    }

    sum := 0;
    for box, box_index: boxes {
        for slot, slot_index: box {
            sum += (box_index + 1) * (slot_index + 1) * slot.focal_length;
        }
    }

    return sum;
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
