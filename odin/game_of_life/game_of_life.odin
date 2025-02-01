package gol

import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:time"
import "core:sys/posix"
import "core:c/libc"
import "core:strings"

W :: 150
H :: 44
INITIAL_ALIVE :: 0.13
SLEEP :: 90 * time.Millisecond
MAX_GENERATIONS :: 1000

DRAW_CHAR :: 'x'

Field :: distinct [H][W]bool

restore_term_attr : posix.termios
has_termios : bool

field_builder : strings.Builder

// Print it
show_field :: proc(field: ^Field, generation: int) {
    strings.builder_reset(&field_builder)
    strings.write_byte(&field_builder, ' ')
    for it in field[0] {
        strings.write_byte(&field_builder, '-')
    }
    strings.write_byte(&field_builder, ' ')
    strings.write_byte(&field_builder, '\n')
    for it in field {
        strings.write_byte(&field_builder, '|')
        for val in it {
            strings.write_byte(&field_builder, (val ? DRAW_CHAR : ' '))
        }
        strings.write_byte(&field_builder, '|')
        strings.write_byte(&field_builder, '\n')
    }
    strings.write_byte(&field_builder, ' ')
    for it in field[0] {
        strings.write_byte(&field_builder, '-')
    }
    strings.write_byte(&field_builder, ' ')
    strings.write_byte(&field_builder, '\n')
    fmt.sbprintln(&field_builder, "Generation", generation)
    fmt.print(strings.to_string(field_builder))
}


wrap :: proc(x: int, max: int) -> int {
    switch {
    case x < 0:
        return max + x
    case x >= max:
        return x - max
    case:
        return x
    }
}

// Checks if this cell should be alive next turn
next_alive :: proc(field: ^Field, x: int, y: int) -> bool {
    count := 0
    for r := -1; r <= 1; r += 1 {
        for c := -1; c <= 1; c += 1 {
            if r == 0 && c == 0 do continue;
            fx := wrap(x + r, len(field))
            fy := wrap(y + c, len(field[0]))
            if field[fx][fy] == true {
                count += 1
            }
        }
    }

    if field[x][y] {
        switch count {
        case 2, 3: return true
        case: return false
        }
    } else {
        return count == 3
    }
    return false
}


// Produce the next field based on the last one
next_field :: proc(last: ^Field, next: ^Field) -> (count_alive: int, changed: bool) {
    for slice, xi in last {
        for was_alive, yi in slice {
            alive := next_alive(last, xi, yi)
            if alive do count_alive += 1
            if alive != was_alive do changed = true
            next[xi][yi] = alive
        }
    }
    return
}


termios_setup :: proc() {

    attr : posix.termios

    if !posix.isatty(posix.STDOUT_FILENO) do return
    if posix.tcgetattr(posix.STDOUT_FILENO, &restore_term_attr) != posix.result.OK do return
    attr = restore_term_attr
    attr.c_lflag &= ~{(.ICANON | .ECHO)}
    attr.c_cc[.VMIN] = 1
    attr.c_cc[.VTIME] = 0
    posix.tcsetattr(posix.STDOUT_FILENO, .TCSAFLUSH, &attr)

    libc.atexit(proc "c" () {
        posix.tcsetattr(posix.STDOUT_FILENO, .TCSANOW, &restore_term_attr)
    })

    has_termios = true
}


termios_goback :: proc() {
    if has_termios {
        fmt.printf("\e[%vA", H + 3, flush=false)
        fmt.printf("\e[%vD", W + 2, flush=false)
    }
}


main :: proc() {
    seed := rand.uint64()
    rand.reset(seed)
    fmt.printfln("Seed %v", seed)

    fields : [2]Field
    active := 0
    for &it in fields[active] {
        for &val in it {
            val = rand.float32() < INITIAL_ALIVE
        }
    }

    termios_setup()

    show_field(&fields[active], 0)

    generation := 0
    count_alive := 0
    for _ in 0..<MAX_GENERATIONS {
        if SLEEP > 0 do time.sleep(SLEEP)

        generation += 1
        changed: bool
        count_alive, changed = next_field(&fields[active], &fields[1 - active])
        if count_alive == 0 {
            fmt.println("All will die next round :(")
            break
        }
        active = (active + 1) % 2
        termios_goback()
        show_field(&fields[active], generation)

        if !changed {
            fmt.println("Repeats forever")
            break
        }
    }
    fmt.printfln("Got to generation %v, with %v/%v: %.1f%% cells alive", generation, count_alive, W*H, f64(100 * count_alive) / (W*H))
}
