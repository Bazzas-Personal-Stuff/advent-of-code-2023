//+private file
package aoc_days

DAY_NUMBER :: 2

import "core:testing"
import "core:strings"
import "core:strconv"
import "core:text/scanner"
import "core:unicode/utf8"


stage_1 :: proc(input: []byte) -> int {
    sum := 0
    input_str := string(input)

    max_in_bag := [3]int {12, 13, 14}

    for game_line in strings.split_lines_iterator(&input_str) {
        is_possible := true
        game := game_line

        _, _ = strings.split_iterator(&game, " ") // strip "Game: " from id half
        game_id_str, _ := strings.split_iterator(&game, ": ")
        game_id := strconv.atoi(game_id_str)

        println("=== Game", game_id)

        max_cubes := get_max_cubes_in_game(&game)
    
        if  max_cubes.r <= max_in_bag.r &&
            max_cubes.g <= max_in_bag.g &&
            max_cubes.b <= max_in_bag.b {
            sum += game_id
        } else {
            println(" impossible")
        }
    }

    return sum
}


stage_2 :: proc(input: []byte) -> int {
    input_str := string(input)
    power_sum := 0
    
    for game_line in strings.split_lines_iterator(&input_str) {
        is_possible := true
        game := game_line

        _, _ = strings.split_iterator(&game, " ") // strip "Game: " from id half
        game_id_str, _ := strings.split_iterator(&game, ": ")
        game_id := strconv.atoi(game_id_str)

        println("=== Game", game_id)

        max_cubes := get_max_cubes_in_game(&game)

        power_sum += max_cubes.r * max_cubes.b * max_cubes.g
    }

    return power_sum
}


get_max_cubes_in_game :: proc(game: ^string) -> [3]int {
    max_counter: [3]int
    for hand in strings.split_iterator(game, "; ") {
        hand_str := hand
        hand_counter: [3]int
        for group in strings.split_iterator(&hand_str, ", ") {
            group_str := group
            group_count_str, _ := strings.split_iterator(&group_str, " ")
            group_count := strconv.atoi(group_count_str)
            switch group_str {
                case "red":
                    print(" r:", group_count)
                    hand_counter.r = group_count
                case "green":
                    print(" g:", group_count)
                    hand_counter.g = group_count
                case "blue":
                    print(" b:", group_count)
                    hand_counter.b = group_count
            }
        }
        println()

        max_counter.r = max(max_counter.r, hand_counter.r)
        max_counter.b = max(max_counter.b, hand_counter.b)
        max_counter.g = max(max_counter.g, hand_counter.g)
    }

    return max_counter
}


// =============================================================================

stage_1_scanner :: proc(input: []byte) -> int {
    s: scanner.Scanner
    scanner.init(&s, string(input))

    for scanner.scan(&s) != utf8.RUNE_EOF {
        println(scanner.token_text(&s))
        // scanner.
    }
    return 0
}

// CONTEXT FREE GRAMMAR
// Game         = "Game", Number, ":", Hand, {";", Hand} ["\n"];
// Hand         = Number, Color, {",", Number, Color};
// Color        = "red" | "green" | "blue";
// Number       = Digit, {Digit};
// Digit        = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9";

// =============================================================================
// =============================================================================
// =============================================================================

input    := as_bytes(`Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green`)

test_1 :: proc(t: ^testing.T) {
    expected := 8
    // answer   := stage_1(input)
    answer   := stage_1_scanner(input)
    
    testing.expect_value(t, answer, expected)
}

test_2 :: proc(t: ^testing.T) {
    expected := 2286
    // answer   := stage_2(input)
    //
    // testing.expect_value(t, answer, expected)
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
