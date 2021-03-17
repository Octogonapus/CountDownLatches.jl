module CountDownLatch

export Latch, await, count_down, get_count

"""
    Latch(count::I) where {I<:Integer}

A `Latch` that starts at some initial non-negative `count`. This latch can be counted down and waited on.
"""
mutable struct Latch
    count::Threads.Atomic{Int64}
    condition::Threads.Condition

    function Latch(count::I) where {I<:Integer}
        if count < 0
            throw(ArgumentError("Count ($count) must not be negative."))
        end

        new(Threads.Atomic{Int64}(count), Threads.Condition(ReentrantLock()))
    end
end

"""
    await(latch::Latch)

Waits until the `latch` has counted down to `<= 0`.
"""
function await(latch::Latch)
    if get_count(latch) <= 0
        return
    end

    lock(latch.condition) do
        while true
            if get_count(latch) <= 0
                return
            end
            wait(latch.condition)
        end
    end
end

"""
    count_down(latch::Latch)

Counts down the `latch` once. This may cause the count to become negative. Any tasks that were blocked in `await` will
be woken if the count becomes `<= 0`.
"""
function count_down(latch::Latch)
    # I think doing something like:
    #
    # 1: count = get_count(latch)
    # 2: count == 0 && return
    # 3: next_count = count - 1
    # 4: if Threads.atomic_cas!(latch.count, count, next_count) == count
    # 5:     lock(latch.condition) do
    # 6:         notify(latch.condition, nothing; all = true, error = false)
    # 7:     end
    # 8: end
    #
    # is wrong here because of the case where a thread decrements count after line 1 and before line 4. In that case,
    # two calls to `notify` must still happen, but only one would.

    Threads.atomic_sub!(latch.count, 1)
    lock(latch.condition) do
        notify(latch.condition, nothing; all = true, error = false)
    end
    nothing
end

"""
    get_count(latch::Latch)

Returns the current count of the `latch`. This count may be negative.
"""
function get_count(latch::Latch)
    latch.count[]
end

end
