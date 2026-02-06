#!/usr/bin/env julia
# Calculate fibonnaci numbers in various ways
# Convention: fib(0) = 0, fib(1) = 1.

function recursive_fib(x::Int64)
    if x <= 0 return 0 end
    if x == 1 return 1 end
    return recursive_fib(x - 1) + recursive_fib(x - 2)
end

function swapping_fib(x)
    a, b = 0, 1
    for count in 1:x
        a, b = b, a + b
    end
    return a
end

function list_fib(x)
    numbers = [0, 1]
    for v in 2:x
        append!(numbers, numbers[v-1] + numbers[v])
    end
    last(numbers)
end

function main()
    println("Recursive fibonnaci:", recursive_fib(10));
    println("Swapping  fibonnaci:", swapping_fib(10));
    println("List      fibonnaci:", list_fib(10));
end

main()
