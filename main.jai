main :: () {
    start_time := get_time();
    defer {
        elapsed := get_time() - start_time;
        log("% ms elapsed.\n", elapsed * 1000);
    }

    day01();
    day02();
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

// Imports

#load "day01.jai";
#load "day02.jai";

#import "Basic";
#import "File";
#import "String";
