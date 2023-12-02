package aoc_2023

import "days"
import "core:fmt"
import "core:log"
import "core:os"
import "core:strconv"
import "core:testing"

main :: proc() {
    // TODO: set up logger for verbose mode

    if len(os.args) < 2 {
        run_all_days()
        return
    }
    
    day, ok := strconv.parse_int(os.args[1])

    if !ok {
        fmt.println("Please enter the day you want to run as an argument.")
        return
    }

    days.verbose = true
    days.run(day)
}

run_all_days :: proc() {
    days.verbose = false
    for i := 1; days.registry[i] != {}; i += 1{
        days.run(i)
    }
}


@(test)
test_stage_1 :: proc(t: ^testing.T) {
    days.verbose = true

    if len(os.args) < 2 {
        fmt.println("Please enter the day you want to run as an argument.")
        testing.fail(t)
        return
    }
    
    day, ok := strconv.parse_int(os.args[1])

    if !ok {
        fmt.println("Please enter the day you want to run as an argument.")
        testing.fail(t)
        return
    }

    days.test_stage_1(t, day)
}

@(test)
test_stage_2 :: proc(t: ^testing.T) {
    days.verbose = true

    if len(os.args) < 2 {
        fmt.println("Please enter the day you want to run as an argument.")
        testing.fail(t)
        return
    }
    
    day, ok := strconv.parse_int(os.args[1])

    if !ok {
        fmt.println("Please enter the day you want to run as an argument.")
        testing.fail(t)
        return
    }

    days.test_stage_2(t, day)
}
