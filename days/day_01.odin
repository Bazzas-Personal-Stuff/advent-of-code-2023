//+private file
package aoc_days

DAY_NUMBER :: 1

import "core:log"
import "core:fmt"
import "core:testing"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"

stage_1 :: proc(input: []byte) -> int {
    sum := 0

    input_str := string(input)
    for line in strings.split_lines_iterator(&input_str) {
        first_num := -1
        last_num := -1

        for char in line {
            // fmt.print(char)
            if char >= '0' && char <= '9' {
                if first_num == -1 {
                    first_num = int(char) - '0'
                }

                last_num = int(char) - '0'
            }
        }

        // fmt.println()
        number := first_num * 10 + last_num
        fmt.println(number, first_num, last_num)

        sum += number
    }

    return sum
}


stage_2 :: proc(input: []byte) -> int {
    return 0
}



// =============================================================================
// =============================================================================
// =============================================================================

test :: proc(t: ^testing.T) {
    s1_input    := as_bytes(`1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet`)
    s1_expected := 142
    s1_answer   := stage_1(s1_input)

    testing.expect_value(t, s1_answer, s1_expected)

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
        test    = test,
    }
}
