module CountDownLatches

export CountDownLatch, await, count_down, get_count

"""
    CountDownLatch(count::I) where {I<:Integer}

A `CountDownLatch` that starts at some initial non-negative `count`. This latch can be counted down and waited on.
"""
mutable struct CountDownLatch{I<:Integer}
    count::Threads.Atomic{I}
    condition::Threads.Condition

    function CountDownLatch(count::I) where {I<:Integer}
        if count < 0
            throw(ArgumentError("Count ($count) must not be negative."))
        end

        new{I}(Threads.Atomic{I}(I(count)), Threads.Condition(ReentrantLock()))
    end
end

"""
    await(latch::CountDownLatch)

Waits until the `latch` has counted down to `<= 0`.
"""
function await(latch::CountDownLatch)
    # Check the count early to possibly avoid a call to lock
    if get_count(latch) <= 0
        return
    end

    lock(latch.condition) do
        while get_count(latch) > 0
            wait(latch.condition)
        end
    end
end

"""
    count_down(latch::CountDownLatch)

Counts down the `latch` once. This may cause the count to become negative. Any tasks that were blocked in `await` will
be woken if the count becomes `<= 0`.
"""
function count_down(latch::CountDownLatch{I}) where {I<:Integer}
    Threads.atomic_sub!(latch.count, I(1))
    lock(latch.condition) do
        notify(latch.condition, nothing; all = true, error = false)
    end
    nothing
end

"""
    get_count(latch::CountDownLatch)

Returns the current count of the `latch`. This count may be negative.
"""
function get_count(latch::CountDownLatch)
    latch.count[]
end

end
