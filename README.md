# CountDownLatch

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Octogonapus.github.io/CountDownLatch.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Octogonapus.github.io/CountDownLatch.jl/dev)
[![Build Status](https://github.com/Octogonapus/CountDownLatch.jl/workflows/CI/badge.svg)](https://github.com/Octogonapus/CountDownLatch.jl/actions)
[![Coverage](https://codecov.io/gh/Octogonapus/CountDownLatch.jl/branch/main/graph/badge.svg?token=MJVL5EVXTP)](https://codecov.io/gh/Octogonapus/CountDownLatch.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package implements a multithreading primitive called a Latch that holds an internal count.
This count can be decremented by multiple threads.
Threads may also wait on the latch's count to become zero.

## Example

In this example, the main thread will be blocked by `await` until the spawned thread counts the latch down.
This is clearly a contrived example, but imagine that there is much more code before `count_down` and before `await`.

```julia
latch = Latch(1)

Threads.@spawn begin
    # Decrease the latch's count by one
    count_down(latch)
end

# Wait until the latch's count become zero
await(latch)
```
