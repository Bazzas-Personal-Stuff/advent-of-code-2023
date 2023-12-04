//+private file
package aoc_days

DAY_NUMBER :: 4

import "core:testing"
import "core:strings"
import "core:strconv"

Int_Set :: map[int]struct{}

stage_1 :: proc(input: []byte) -> int {
    sum := 0

    input_string := string(input)

    winning_set: Int_Set

    card_id := 0
    for line in strings.split_lines_iterator(&input_string) {
        line := line
        card_id += 1
        clear(&winning_set)

        _, _ = strings.split_iterator(&line, ": ")
        winning_nums, _ := strings.split_iterator(&line, " | ",)

        for num_str in strings.split_iterator(&winning_nums, " ") {
            if num_str == "" do continue
            num := strconv.atoi(num_str)
            winning_set[num] = {} // set insert
        }
        
        println(card_id, "Winning set:", winning_set)
        
        card_score := 0
        for num_str in strings.split_iterator(&line, " ") {
            if num_str == "" do continue
            num := strconv.atoi(num_str)
            if num in winning_set {
                println("Matched:", num)
                card_score = 1 if card_score == 0 else card_score * 2
            }
        }
        println("Card score:", card_score)
        sum += card_score
    }

    return sum
}


stage_2 :: proc(input: []byte) -> int {
    return 0
}



// =============================================================================
// =============================================================================
// =============================================================================

test_input := as_bytes(`Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11`)

test_1 :: proc(t: ^testing.T) {
    expected := 13
    answer   := stage_1(test_input)
    
    testing.expect_value(t, answer, expected)
}

test_2 :: proc(t: ^testing.T) {
    expected := -1
    answer   := stage_2(test_input)

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
