module CountDownLatch

export Latch, await, count_down, get_count

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

function await(latch::Latch)
    lock(latch.condition) do
        while true
            if get_count(latch) == 0
                return
            end
            wait(latch.condition)
        end
    end
end

function count_down(latch::Latch)
    Threads.atomic_sub!(latch.count, 1)
    lock(latch.condition) do
        notify(latch.condition, nothing; all = true, error = false)
    end
    nothing
end

function get_count(latch::Latch)
    latch.count[]
end

end
