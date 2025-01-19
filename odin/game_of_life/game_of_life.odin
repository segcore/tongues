package gol

import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:time"

W :: 80
H :: 20
INITIAL_ALIVE :: 0.20
SLEEP :: 50 * time.Millisecond

Field :: distinct [H][W]bool

// Print it
show_field :: proc(field: ^Field) {
    fmt.print(' ')
    for it in field[0] {
        fmt.print('-')
    }
    fmt.println(' ')
    for it in field {
        fmt.print('|')
        for val in it {
            fmt.print(val ? "x" : " ")
        }
        fmt.println('|')
    }
    fmt.print(' ')
    for it in field[0] {
        fmt.print('-')
    }
    fmt.println(' ')
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


main :: proc() {
    seed := rand.uint64()
    rand.reset(seed)

    fields : [2]Field
    active := 0
    for &it in fields[active] {
        for &val in it {
            val = rand.float32() < INITIAL_ALIVE
        }
    }

    show_field(&fields[active])

    generation := 0
    for _ in 0..<1000 {
        generation += 1
        count_alive, changed := next_field(&fields[active], &fields[1 - active])
        active = (active + 1) % 2
        show_field(&fields[active])

        if !changed {
            fmt.println("Repeats forever")
            break
        }
        if count_alive == 0 {
            fmt.println("All gone :(")
            break
        }

        if SLEEP > 0 do time.sleep(SLEEP)
    }
    fmt.printfln("Got to generation %v, seed = %v", generation, seed)
}
