//+private file
package aoc_days

DAY_NUMBER :: 1

import "core:testing"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"
import "core:text/match"

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

        number := first_num * 10 + last_num
        println(number, first_num, last_num)

        sum += number
    }

    return sum
}


// Lookahead, don't consume letters that might overlap the start of other words
// regex := "zer(?=o)|on(?=e)|two|thre(?=e)|four|fiv(?=e)|six|seve(?=n)|eigh(?=t)|nin(?=e)|\\d"

words := []string {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",}

stage_2 :: proc(input: []byte) -> int {
    sum := 0

    input_str := string(input)
    // temp_line_builder: strings.Builder

    for line in strings.split_lines_iterator(&input_str) {

        earliest_pos := max(int)
        earliest_val := 0
        latest_pos  := -1
        latest_val  := 0

        for word, i in words {
            matcher := match.matcher_init(line, word)
            // find first of each word
            // find last of each word
            for word_match, j in match.matcher_match_iter(&matcher) {
                // if words_
            }
        }

        // also check for digits

        // sum += first_num * 10 + last_num
        
    }

    return sum
}


// state tree entry points

//      o           t            f         s         e       n
//      n        w  h  e       o   i     i   e       i       i
//      E        O  r  N       u   v     X   v       g       n
//                  e          R   E         e       h       E
//                  E                        N       T

// =============================================================================
// =============================================================================
// =============================================================================

test_1 :: proc(t: ^testing.T) {
    s1_input    := as_bytes(`1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet`)
    s1_expected := 142
    s1_answer   := stage_1(s1_input)

    testing.expect_value(t, s1_answer, s1_expected)
}

test_2 :: proc(t: ^testing.T) {
    s2_input    := as_bytes(`two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen`)
    s2_expected := 281
    s2_answer   := stage_2(s2_input)
    
    testing.expect_value(t, s2_answer, s2_expected)
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
