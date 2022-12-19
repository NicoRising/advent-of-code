function main()
    lines = readlines(open("input.txt"))

    sensors = Vector{Tuple{Int, Int, Int}}()

    for line in lines
        nums = [parse(Int, num.match) for num in eachmatch(r"[\d-]+", line)]

        push!(sensors, (
            nums[1],
            nums[2],
            abs(nums[1] - nums[3]) + abs(nums[2] - nums[4])
        ))
    end

    count = 0
    found = false

    for x in 0:4_000_000
        y = 0

        while y < 4_000_000
            found = true

            for sensor in sensors
                if abs(sensor[1] - x) + abs(sensor[2] - y) <= sensor[3]
                    y = sensor[2] + sensor[3] - abs(sensor[1] - x) + 1 # Move search to past slice of current sensor
                    found = false
                end
            end

            if found
                println(x * 4_000_000 + y) 
                break
            end
        end

        if found
            break
        end
    end
end

main()
