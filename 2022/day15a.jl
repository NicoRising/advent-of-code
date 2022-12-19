function main()
    lines = readlines(open("input.txt"))

    sensors = Vector{Tuple{Int, Int, Int}}()
    beacons = Set{Tuple{Int, Int}}()

    for line in lines
        nums = [parse(Int, num.match) for num in eachmatch(r"[\d-]+", line)]

        push!(sensors, (
            nums[1],
            nums[2],
            abs(nums[1] - nums[3]) + abs(nums[2] - nums[4])
        ))

        push!(beacons, (nums[3], nums[4]))
    end

    min_x = minimum([sensor[1] - sensor[3] for sensor in sensors])
    max_x = maximum([sensor[1] + sensor[3] for sensor in sensors])

    count = 0

    for x in min_x:max_x
        if !((x, 2_000_000) in beacons)
            for sensor in sensors
                if abs(sensor[1] - x) + abs(sensor[2] - 2_000_000) <= sensor[3]
                    count += 1
                    break
                end
            end
        end
    end

    println(count)
end

main()
