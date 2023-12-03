//+private file
package aoc_days

DAY_NUMBER :: 3

import "core:testing"
import "core:strings"
import "core:strconv"
import "core:bytes"

AABB :: struct {
    min: [2]int,
    max: [2]int,
}

Symbol_Entry :: struct {
    position:   [2]int,
    value:      byte,
}

Number_Entry :: struct {
    bounds: AABB,
    value:  int,
}

Number_Scanner :: struct {
    accumulator: int,
    begin_index: int,
    digit_count: int,
}

stage_1 :: proc(input: []byte) -> int {
    sum := 0

    // load into 2d array
    world := bytes.split(input, {'\n'})
    defer delete(world)
    
    numbers: [dynamic]Number_Entry
    symbols: [dynamic]Symbol_Entry
    defer delete(numbers)
    defer delete(symbols)

    scan_world(world, &numbers, &symbols)

    for number in numbers {
        print(number.value, "overlaps: ")
        
        has_overlaps := false
        for symbol in symbols {
            if is_in_bounds(symbol.position, number.bounds) {
                print(rune(symbol.value), "")
                has_overlaps = true
            }
        }

        if !has_overlaps {
            print("NONE")
        } else {
            sum += number.value
        }

        println()
    }

    return sum
}


stage_2 :: proc(input: []byte) -> int {
    sum := 0

    // load into 2d array
    world := bytes.split(input, {'\n'})
    defer delete(world)
    
    numbers: [dynamic]Number_Entry
    symbols: [dynamic]Symbol_Entry
    defer delete(numbers)
    defer delete(symbols)

    scan_world(world, &numbers, &symbols)


    SYMBOL_LOOP: for symbol in symbols {
        if symbol.value != '*' {
            continue
        }
        print(rune(symbol.value), "overlaps: ")

        adj_numbers: [2]int
        adj_number_count := 0

        for number in numbers {
            if is_in_bounds(symbol.position, number.bounds) {
                adj_numbers[adj_number_count] = number.value
                print(number.value, "")
                adj_number_count += 1
                if adj_number_count > 2 {
                    println("\tNOT GEAR (more)")
                    continue SYMBOL_LOOP
                }
            }
        }

        if adj_number_count == 2 {
            sum += adj_numbers[0] * adj_numbers[1]
            println()
        } else {
            println ("\tNOT GEAR (less)")
        }
    }

    return sum
}


number_scanner_scan :: proc(scanner: ^Number_Scanner, value: byte, col: int) {
    value := value - '0' // convert from ascii to int

    if scanner.digit_count == 0 {
        scanner.begin_index = col
    }
    scanner.digit_count += 1
    scanner.accumulator *= 10
    scanner.accumulator += int(value)
}

number_scanner_push :: proc(scanner: ^Number_Scanner, numbers: ^[dynamic]Number_Entry, row: int)  {
    if scanner.digit_count <= 0 {
        return
    }

    entry := Number_Entry {
        value = scanner.accumulator,
        bounds = {
            min = {row - 1, scanner.begin_index - 1},
            max = {row + 1, scanner.begin_index + scanner.digit_count},
        },
    }

    append(numbers, entry)

    scanner.begin_index = 0
    scanner.digit_count = 0
    scanner.accumulator = 0
}

is_in_bounds :: proc(pos: [2]int, bounds: AABB) -> bool {
    return  pos.x >= bounds.min.x &&
            pos.x <= bounds.max.x &&
            pos.y >= bounds.min.y &&
            pos.y <= bounds.max.y
}

scan_world :: proc(world: [][]byte, numbers: ^[dynamic]Number_Entry, symbols: ^[dynamic]Symbol_Entry) {
    scanner: Number_Scanner

    for row, i in world {
        for char, j in row {
            if char == '.' {
                number_scanner_push(&scanner, numbers, i)
            } else if char >= '0' && char <= '9' {
                number_scanner_scan(&scanner, char,  j)
            } else {
                number_scanner_push(&scanner, numbers, i)
                entry := Symbol_Entry {
                    value = char,
                    position = {i, j},
                }
                append(symbols, entry)
            }
            
        }
        number_scanner_push(&scanner, numbers, i)
    }

}

// =============================================================================
// =============================================================================
// =============================================================================
test_input := as_bytes(`467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`)

test_1 :: proc(t: ^testing.T) {
    expected := 4361
    answer   := stage_1(test_input)
    
    testing.expect_value(t, answer, expected)
}

test_2 :: proc(t: ^testing.T) {
    expected := 467835
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
