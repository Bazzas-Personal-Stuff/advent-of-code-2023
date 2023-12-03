//+private file
package aoc_days

DAY_NUMBER :: 3

import "core:testing"
import "core:strings"
import "core:strconv"

stage_1 :: proc(input: []byte) -> int {
    return 0
}


stage_2 :: proc(input: []byte) -> int {
    return 0
}



// =============================================================================
// =============================================================================
// =============================================================================

test_1 :: proc(t: ^testing.T) {
    input    := as_bytes(`467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`)
    expected := 4361
    answer   := stage_1(input)
    
    testing.expect_value(t, answer, expected)
}

test_2 :: proc(t: ^testing.T) {
    input    := as_bytes(``)
    expected := -1
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
