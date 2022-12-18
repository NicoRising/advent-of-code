function main()
    paths = readlines(open("input.txt"))
    rocks = Set{Tuple{Int, Int}}()

    for path in paths
        points = Vector{Tuple{Int, Int}}()

        for point in eachmatch(r"(?<x>\d+),(?<y>\d+)", path)
            push!(points, (parse(Int, point[:x]) + 1, parse(Int, point[:y]) + 1)) # 1-indexes
        end

        for i in 1:(length(points) - 1)
            if points[i][1] != points[i + 1][1]
                if points[i][1] <= points[i + 1][1]
                    range = points[i][1]:points[i + 1][1]
                else
                    range = points[i + 1][1]:points[i][1]
                end

                union!(rocks, [(x, points[i][2]) for x in range])
            else
                if points[i][2] <= points[i + 1][2]
                    range = points[i][2]:points[i + 1][2]
                else
                    range = points[i + 1][2]:points[i][2]
                end

                union!(rocks, [(points[i][1], y) for y in range])
            end
        end
    end

    min_y = 1
    max_y = maximum([rock[2] for rock in rocks])

    min_x = 501 - max_y
    max_x = 501 + max_y

    grid = zeros(Bool, max_x - min_x + 1, max_y - min_y + 2)

    for (x, y) in rocks
        grid[x - min_x + 1, y - min_y + 1] = true
    end

    sand = [501 - min_x + 1, 1]
    count = 0

    while !grid[501 - min_x + 1, 1]
        if sand[2] + 1 <= size(grid)[2]
            if !grid[sand[1], sand[2] + 1]
                sand[2] += 1
            elseif !grid[sand[1] - 1, sand[2] + 1]
                sand[1] -= 1
                sand[2] += 1
            elseif !grid[sand[1] + 1, sand[2] + 1]
                sand[1] += 1
                sand[2] += 1
            else
                grid[sand...] = true
                sand = [501 - min_x + 1, 1]
                count += 1
            end
        else
            grid[sand...] = true
            sand = [501 - min_x + 1, 1]
            count += 1
        end
    end

    println(count)
end

main()
