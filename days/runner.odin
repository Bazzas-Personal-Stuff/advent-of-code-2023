package aoc_days

import "core:fmt"
import "core:os"
import "core:strings"
import "core:testing"

// Individual challenges self-register using a @(init) proc
registry : [26]Challenge_Program

verbose: bool = false

Challenge_Program :: struct {
    stage_1 : proc(input: []byte) -> int,
    stage_2 : proc(input: []byte) -> int,
    test    : proc(t: ^testing.T)
}

Stage :: enum {
    _1,
    _2,
}

run :: proc(day: int) {
    if day <= 0 || day > 25 {
        fmt.println("Invalid day:", day)
        return
    }

    day_program := &registry[day]

    if day_program == {} {
        fmt.println("Invalid day:", day)
        return
    }

    filename_sb := strings.builder_make()
    fmt.sbprintf(&filename_sb, "inputs/%2d.txt", day)
    defer strings.builder_destroy(&filename_sb)
    
    input, _ := os.read_entire_file_from_filename(strings.to_string(filename_sb))
    defer delete(input)

    if day_program.stage_1 == nil {
        fmt.println("No stage 1 exists for day", day)
        return
    }

    fmt.println("===== Day", day, "- Stage 1 =====")
    fmt.println(day_program.stage_1(input), "\n")

    if day_program.stage_2 == nil {
        return
    }
    fmt.println("===== Day", day, "- Stage 2 =====")
    fmt.println(day_program.stage_2(input), "\n")

    return
}


test :: proc(t: ^testing.T, day: int) {
    if day <= 0 || day > 25 {
        testing.error(t, "Invalid day: ", day)
        return
    }

    day_program := &registry[day]

    if day_program.test == nil {
        testing.error(t, "Test proc doesn't exist for day:", day)
        return
    }

    day_program.test(t)
    return
}


// Helpers

as_bytes :: proc(str: string) -> []byte {
    return transmute([]byte)str
}