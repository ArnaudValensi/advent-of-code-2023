main :: () {
    start_time := get_time();
    defer {
        elapsed := get_time() - start_time;
        log("% ms elapsed.\n", elapsed * 1000);
    }

    // day01();
    // day02();
    // day03();
    // day04();
    // day05();
    // day06();
    // day07();
    // day08();
    // day09();
    // day10();
    // day11();
    // day12();
    // day13();
    // day14();
    // day15();
    day16();
}

// Utils.

read_u8  :: s => read_number(u8,  s);
read_u16 :: s => read_number(u16, s);
read_u32 :: s => read_number(u32, s);
read_u64 :: s => read_number(u64, s);
read_s8  :: s => read_number(s8,  s);
read_s16 :: s => read_number(s16, s);
read_s32 :: s => read_number(s32, s);
read_s64 :: s => read_number(s64, s);

read_word :: (s: *string) -> string
{
    word := <<s;
    word.count = 0;

    while s.count && !is_whitespace(s.data[0])
    {
        word.count += 1;
        advance(s);
    }

    skip_whitespace(s);

    return word;
}

skip_whitespace :: (s: *string)
{
    while s.count && is_whitespace(s.data[0])
    {
        advance(s);
    }
}

is_whitespace :: (c: u8) -> bool
{
    return c == #char " " || c == #char "\n" || c == #char "\r" || c == #char "\t";
}

skip_to_next_line :: (s: *string)
{
    while s.count && s.data[0] != #char "\n" advance(s);
    if s.count advance(s);
}

read_number :: ($T: Type, s: *string, $skip_trailing_whitespace := true) -> T
{
    num : T;

    #if T == s8 || T == s16 || T == s32 || T == s64
    {
        neg : bool;

        if s.count && s.data[0] == #char "-"
        {
            neg = true;
            advance(s);
        }
    }

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    #if skip_trailing_whitespace skip_whitespace(s);

    #if T == s8 || T == s16 || T == s32 || T == s64
    {
        return ifx neg then -num else num;
    }
    else
    {
        return num;
    }
}

character_to_string :: (x: u8) -> string {
    s: string;
    s.count = 1;
    s.data = alloc(1);
    s[0] = x;
    return s;
}

next_line :: (s : *string) -> string {
    assert(s.count > 0);

    result : string;

    // Line ending (unix).
    eol : string = "\n";

    // Find next line ending.
    end := find_index_from_left(<<s, eol);

    // End of string.
    if end == -1 {
        end = s.count;
    }

    // Compute result.
    result = <<s;
    result.count = end;

    // Advance string.
    increment := end + eol.count;
    s.data += increment;
    s.count -= increment;

    return result;
}

read_next_split :: (s: *string, separator: u8) -> string
{
    word := <<s;
    word.count = 0;

    while s.count && s.data[0] != separator {
        word.count += 1;
        advance(s);
    }

    while s.count && s.data[0] == separator {
        advance(s);
    }

    return word;
}

array_contains :: (array: []$T, item: T) -> bool {
    for element: array {
        if element == item {
            return true;
        }
    }
    return false;
}

push_temporary_allocator :: () #expand {
    assert(temporary_allocator.proc != null);

    old_allocator     := context.allocator;
    context.allocator  = temporary_allocator;

    `defer context.allocator = old_allocator;
}

// Imports

#load "day01.jai";
#load "day02.jai";
#load "day03.jai";
#load "day04.jai";
#load "day05.jai";
#load "day06.jai";
#load "day07.jai";
#load "day08.jai";
#load "day09.jai";
#load "day10.jai";
#load "day11.jai";
#load "day12.jai";
#load "day13.jai";
#load "day14.jai";
#load "day15.jai";
#load "day16.jai";

#import "Basic";
#import "File";
#import "String";
Hash :: #import "Hash";
#import "Hash_Table";
#import "Math";
#import "Sort";
#import "Print_Color";
