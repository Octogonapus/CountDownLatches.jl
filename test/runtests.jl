using CountDownLatch
using Test
using ThreadPools

@testset "create a latch with a negative count" begin
    @test_throws ArgumentError Latch(-1)
end

@testset "count down from 1" begin
    latch = Latch(1)
    count_down(latch)
    await(latch)
    @test get_count(latch) == 0
end

@testset "count down from 1 two times" begin
    latch = Latch(1)
    count_down(latch)
    count_down(latch)
    await(latch)
    @test get_count(latch) == -1
end

@testset "wait for another thread to count down from 1" begin
    latch = Latch(1)

    t = Threads.@spawn begin
        count_down(latch)
    end
    
    await(latch)
    
    @test get_count(latch) == 0
    @test istaskdone(t)
end

@testset "mutual count down" begin
    latch1 = Latch(1)
    latch2 = Latch(1)
    latch3 = Latch(1)

    t = Threads.@spawn begin
        count_down(latch2)
        await(latch1)
        count_down(latch3)
    end

    await(latch2)
    count_down(latch1)
    await(latch3)

    @test get_count(latch1) == 0
    @test get_count(latch2) == 0
    @test get_count(latch3) == 0
    @test istaskdone(t)
end

@testset "wait for another thread to count down from 2" begin
    latch = Latch(2)
    
    t = Threads.@spawn begin
        count_down(latch)
        count_down(latch)
    end
    
    await(latch)
    
    @test get_count(latch) == 0
    @test istaskdone(t)
end

@testset "wait for this thread to count down from 2 using ThreadPools" begin
    latch = Latch(2)

    this_thread_id = Threads.threadid()
    @tspawnat this_thread_id begin
        # I would like to assert that await() was called but this is the best I can come up with
        @test get_count(latch) == 1
        count_down(latch)
    end
    count_down(latch)
    await(latch)
    
    @test get_count(latch) == 0
end
