function main()
    lines = readlines(open("input.txt"))
    
    grid = Matrix{Char}(undef, length(lines[1]), length(lines))
    starts = Vector{Tuple{Int, Int}}()
    target = nothing

    for (y, line) in enumerate(lines)
        for (x, char) in enumerate(line)
            if char == 'S'
                start = (x, y)
                char = 'a'
            elseif char == 'E'
                target = (x, y)
                char = 'z'
            end

            if char == 'a'
                push!(starts, (x, y))
            end

            grid[x, y] = char
        end
    end

    neighbors = Matrix{Vector{Tuple{Int, Int}}}(undef, size(grid))

    for x in 1:size(grid)[1]
        for y in 1:size(grid)[2]
            neighbors[x, y] = []

            for neighbor in [(x + 1, y), (x, y + 1), (x - 1, y), (x, y -1)]
                if 1 <= neighbor[1] <= size(grid)[1] && 1 <= neighbor[2] <= size(grid)[2]
                    if grid[neighbor...] <= grid[x, y] + 1
                        push!(neighbors[x, y], neighbor)
                    end
                end
            end
        end
    end

    min_depth = nothing

    for start in starts
        queue = Vector{Tuple{Tuple{Int, Int}, Int}}()
        visited = Set{Tuple{Int, Int}}()

        push!(queue, (start, 0))
        index = 1

        while index <= length(queue)
            (current, depth) = queue[index]

            if current == target
                if isnothing(min_depth) || depth < min_depth
                    min_depth = depth
                end

                break
            end

            for neighbor in neighbors[current...]
                if !(neighbor in visited)
                    push!(queue, (neighbor, depth + 1))
                    push!(visited, neighbor)
                end
            end

            index += 1
        end
    end

    println(min_depth)
end

main()
