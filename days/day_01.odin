//+private file
package aoc_days

DAY_NUMBER :: 1

import "core:testing"
import "core:strings"
import "core:strconv"
// import "../community/regex"
import "core:text/match"
import "core:mem"

stage_1 :: proc(input: []byte) -> int {
    sum := 0

    input_str := string(input)
    for line in strings.split_lines_iterator(&input_str) {
        first_num := -1
        last_num := -1

        for char in line {
            if char >= '0' && char <= '9' {
                if first_num == -1 {
                    first_num = int(char) - '0'
                }

                last_num = int(char) - '0'
            }
        }
        
        println(line)
        println("First:", first_num, "Last:", last_num)

        number := first_num * 10 + last_num

        sum += number
    }

    return sum
}


// Lookahead, don't consume letters that might overlap the start of other words
// r := "zer(?=o)|on(?=e)|tw(?=o)|thre(?=e)|four|fiv(?=e)|six|seve(?=n)|eigh(?=t)|nin(?=e)|\\d"
// Can't use regex, library doesn't work with lookaheads

stage_2 :: proc(input: []byte) -> int {
    input_str := string(input)
    
    sum := 0

    for line in strings.split_lines_iterator(&input_str) {
        arena_temp_memory: mem.Arena_Temp_Memory

        first_idx   := max(int)
        first_val   := 0
        last_idx    := min(int)
        last_val    := 0

        for k, v in token_to_int {
            line := line
            matcher := match.matcher_init(line, k)
            offset := 0
            for start, end in match.matcher_find(&matcher) 
            {
                if start + offset < first_idx {
                    first_val = v
                    first_idx = start + offset
                }
                
                if start + offset > last_idx {
                    last_val = v
                    last_idx = start + offset
                }
                // advance
                matcher.haystack = matcher.haystack[end:]
                offset += end
            }
        }

        println(line)
        println("First:", first_val, "Last:", last_val)
        sum += first_val * 10 + last_val
    }

    return sum
}

token_to_int := map[string]int {
    "0" = 0,
    "1" = 1,
    "2" = 2,
    "3" = 3,
    "4" = 4,
    "5" = 5,
    "6" = 6,
    "7" = 7,
    "8" = 8,
    "9" = 9,
    "zero" =    0,
    "one" =     1,
    "two" =     2,
    "three" =   3,
    "four" =    4,
    "five" =    5,
    "six" =     6,
    "seven" =   7,
    "eight" =   8,
    "nine" =    9,
}

// =============================================================================
// =============================================================================
// =============================================================================

test_1 :: proc(t: ^testing.T) {
    input    := as_bytes(`1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet`)
    expected := 142
    answer   := stage_1(input)

    testing.expect_value(t, answer, expected)
}

test_2 :: proc(t: ^testing.T) {
    input    := as_bytes(`two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen`)
    expected := 281
    answer   := stage_2(input)
    
    testing.expect_value(t, answer, expected)
}

@(init)
register :: proc() {
    registry[DAY_NUMBER] = Challenge_Program {
        stage_1 = stage_1,
        stage_2 = stage_2,
        test_1  = test_1,
        test_2  = test_2,
    }
}
