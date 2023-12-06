//+private file
package aoc_days

DAY_NUMBER :: 5

import "core:testing"
import "core:strings"
import "core:strconv"
import "core:bufio"
import "core:io"
import "core:bytes"
import "core:slice"

Range_Entry :: struct {
    src_min:    int,
    src_max:    int,
    dst_offset: int,
}

Range_Map :: [dynamic]Range_Entry

Seed_Maps :: struct {
    seed_soil       : Range_Map,
    soil_fert       : Range_Map,
    fert_water      : Range_Map,
    water_light     : Range_Map,
    light_temp      : Range_Map,
    temp_humid      : Range_Map,
    humid_loc       : Range_Map,
}

stage_1 :: proc(input: []byte) -> int {
    input_string := string(input)
    
    seeds_list := make([dynamic]int); defer delete(seeds_list)
    
    // First line has seeds
    seeds_line, _ := strings.split_lines_iterator(&input_string)

    _, _ = strings.split_iterator(&seeds_line, " ") // Discard "seeds:"
    for seed_id in strings.split_iterator(&seeds_line, " ") {
        append(&seeds_list, strconv.atoi(seed_id))
    }

    seed_maps := parse_maps(&input_string)
    defer delete_seed_maps(&seed_maps)
   
    lowest_loc: int = max(int)

    for seed in seeds_list {
        loc := get_seed_location(&seed_maps, seed)
        if loc < lowest_loc {
            lowest_loc = loc
        }
    }

    return lowest_loc
}


stage_2 :: proc(input: []byte) -> int {
    // TODO: Optimise 
    if true do return 0 // Current solution takes ~4:30. Comment this line to run it anyway.

    input_string := string(input)
    
    seed_ranges := make([dynamic][2]int); defer delete(seed_ranges)
    
    seeds_line, _ := strings.split_lines_iterator(&input_string)

    _, _ = strings.split_iterator(&seeds_line, " ") // Discard "seeds:"
    for seed_id_str in strings.split_iterator(&seeds_line, " ") {
        range : [2]int
        range_len_str, _ := strings.split_iterator(&seeds_line, " ")

        range[0] = strconv.atoi(seed_id_str)
        range[1] = range[0] + strconv.atoi(range_len_str)

        append(&seed_ranges, range)
    }
    
    seed_maps := parse_maps(&input_string)
    defer delete_seed_maps(&seed_maps)

    lowest_loc: int = max(int)

    for range in seed_ranges {
        for seed in range[0]..<range[1] {
            loc := get_seed_location(&seed_maps, seed)
            if loc < lowest_loc {
                lowest_loc = loc
            }
        }
    }

    return lowest_loc
}

parse_maps :: proc(input: ^string) -> Seed_Maps {
    seed_maps: Seed_Maps

    target_map: ^Range_Map
    for line in strings.split_lines_iterator(input) {
        if line == "" do continue

        switch line {
        case "seed-to-soil map:":
            target_map = &seed_maps.seed_soil
            continue
        case "soil-to-fertilizer map:":
            target_map = &seed_maps.soil_fert
            continue
        case "fertilizer-to-water map:":
            target_map = &seed_maps.fert_water
            continue
        case "water-to-light map:":
            target_map = &seed_maps.water_light
            continue
        case "light-to-temperature map:":
            target_map = &seed_maps.light_temp
            continue
        case "temperature-to-humidity map:":
            target_map = &seed_maps.temp_humid
            continue
        case "humidity-to-location map:":
            target_map = &seed_maps.humid_loc
            continue
        }
       
        line := line
        nums: [3]int
        for &num in nums {
            num_str, _ := strings.split_iterator(&line, " ") 
            num = strconv.atoi(num_str)
        }

        range_map_insert(target_map, nums[0], nums[1], nums[2])
    }

    return seed_maps
}


delete_seed_maps :: proc(maps: ^Seed_Maps) {
    delete(maps.seed_soil)
    delete(maps.soil_fert)
    delete(maps.fert_water)
    delete(maps.water_light)
    delete(maps.light_temp)
    delete(maps.temp_humid)
    delete(maps.humid_loc)
}


get_seed_location :: proc(seed_maps: ^Seed_Maps, seed: int) -> int {
    soil    := range_map_get(&seed_maps.seed_soil, seed)
    fert    := range_map_get(&seed_maps.soil_fert, soil)
    water   := range_map_get(&seed_maps.fert_water, fert)
    light   := range_map_get(&seed_maps.water_light, water)
    temp    := range_map_get(&seed_maps.light_temp, light)
    humid   := range_map_get(&seed_maps.temp_humid, temp)
    loc     := range_map_get(&seed_maps.humid_loc, humid)

    println("seed", seed, "soil", soil, "fert", fert, "water", water, "light", light, "temp", temp, "humid", humid, "loc", loc)
    return loc
}


range_map_insert :: proc(range_map: ^Range_Map, dst_start, src_start, range_length: int) {
    entry := Range_Entry {
        src_min     = src_start,
        src_max     = src_start + range_length,
        dst_offset  = dst_start - src_start,
    }

    append(range_map, entry)
}


range_map_get :: proc(range_map: ^Range_Map, key: int) -> (value: int) {
    for entry in range_map {
        if key >= entry.src_min && key < entry.src_max {
            return key + entry.dst_offset
        }
    }

    return key
}


// =============================================================================
// =============================================================================
// =============================================================================

test_input := as_bytes(`seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4`)

test_1 :: proc(t: ^testing.T) {
    expected := 35
    answer   := stage_1(test_input)
    
    testing.expect_value(t, answer, expected)
}

test_2 :: proc(t: ^testing.T) {
    expected := 46
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
