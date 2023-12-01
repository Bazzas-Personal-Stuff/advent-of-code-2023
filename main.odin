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

    days.run(day)
}

run_all_days :: proc() {
    for i := 1; days.registry[i] != {}; i += 1{
        days.run(i)
    }
}


@(test)
test :: proc(t: ^testing.T) {
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

    days.test(t, day)
}
