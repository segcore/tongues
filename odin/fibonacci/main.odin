package fibonnaci

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:math"

fib :: proc(a:int) -> int {
    if a <= 0 {
        return 0
    } else if a == 1 {
        return 1;
    } else {
        return fib(a - 1) + fib(a - 2);
    }
}

fibi :: proc(n: int) -> int {
    a := 0
    b := 1
    n := n
    for n > 0 {
        c := a + b
        a = b
        b = c
        n -= 1;
    }
    return a
}

fibgen :: proc(a, b : ^int) {
    c := a^ + b^
    a^ = b^
    b^ = c
}

fibgenret :: proc(a, b: int) -> (int, int) {
    c := a + b
    a := b
    b := c
    return a,b
}

fibarray :: proc(n: int) -> [dynamic]int {
    list : [dynamic]int
    a, b := 0, 1
    n := n
    for n >= 0 {
        append(&list, a);
        a, b = b, a + b
        n -= 1
    }
    return list
}

fibcalc :: proc(n: int) -> int {
    // The golden ratio
    gr :: 1.618033988749894848204586834365638117720309179805
    n := f64(n)
    xn := (math.pow(gr, n) - math.pow((1 - gr), n)) / math.sqrt_f64(5)
    return int(xn)
}

main :: proc() {
    fmt.println("Args ", os.args[1:])
    val := 10
    if len(os.args) > 1 {
        x, ok := strconv.parse_int(os.args[1])
        if !ok {
            fmt.eprintln("Could not parse integer from command line argument ", os.args[1])
            os.exit(1)
        } else {
            val = x
        }
    }
    fmt.println("fib (", val, ") = ", fib(val))
    fmt.println("fibi(", val, ") = ", fibi(val))

    fmt.print("fibgen ")
    a, b := 0, 1
    for i in 0..=val {
        fmt.print(a, "")
        fibgen(&a, &b)
    }
    fmt.println()

    fmt.print("fibgenret ")
    a, b = 0, 1
    for i in 0..=val {
        fmt.print(a, "")
        a, b = fibgenret(a, b)
    }
    fmt.println()

    fmt.println("fibarray", fibarray(val))
    fmt.println("fibcalc", fibcalc(val))
}
