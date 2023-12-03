package aoc_2023

import "days"
import "core:fmt"
import "core:log"
import "core:os"
import "core:strconv"
import "core:testing"
import "core:time"

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
    answer_1, answer_2 := days.run(day)
    fmt.printf("===== DAY %2d SUMMARY =====\n", day)
    fmt.println(" - Stage 1:   ", answer_1)
    fmt.println(" - Stage 2:   ", answer_2)
}

run_all_days :: proc() {
    days.verbose = false
    stopwatch: time.Stopwatch

    for i := 1; days.registry[i] != {}; i += 1{
        time.stopwatch_reset(&stopwatch)
        time.stopwatch_start(&stopwatch)
        answer_1, answer_2 := days.run(i)
        time.stopwatch_stop(&stopwatch)

        fmt.printf("===== DAY %2d SUMMARY =====\n", i)
        fmt.println(" -    Time:   ", time.stopwatch_duration(stopwatch))
        fmt.println(" - Stage 1:   ", answer_1)
        fmt.println(" - Stage 2:   ", answer_2)
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
