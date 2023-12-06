package lexer

import "core:log"

Token_Type :: enum {}

Token :: struct {
    type:   Token_Type,
    lexeme: string,
    // literal: ,
    line:   int,
    col:    int,
}

Scanner :: struct {
    source: string,
    iter:   string,
    cursor: int,
    line:   int,
}


scanner_init :: proc(source: string) -> Scanner {
    scanner := Scanner {
        source  = source,
        iter    = source[:],
        cursor  = 0,
        line    = 0,
    }

    return scanner
}


scanner_scan :: proc(scanner: ^Scanner, allocator := context.allocator) -> (tokens: [dynamic]Token, ok: bool) {
    ok = true

    toks, err := make([dynamic]Token, allocator)
    if err != .None {
        log.error("Alloc error:", err)
        return {}, false
    }


    unimplemented()
}

// ===================================================================================================================

scanner_scan_number :: proc(scanner: ^Scanner) {

}

scanner_scan_token :: proc(scanner: ^Scanner, tokens: ^[dynamic]Token) {

}

scanner_advance :: proc(scanner: ^Scanner) {}

scanner_peek :: proc(scanner: ^Scanner) -> byte {
    if scanner_is_at_end(scanner) {
        return 0
    }

    return scanner.iter[0]
}

scanner_rewind :: proc(scanner: ^Scanner, amount: int = 1) {
    scanner.cursor  -= amount
    scanner.iter    = scanner.source[scanner.cursor:]
}

scanner_is_at_end :: proc(scanner: ^Scanner) -> bool {
    return len(scanner.iter) > 0
}
