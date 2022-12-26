function main()
    lines = readlines(open("input.txt"))
    cubes = Set{Tuple{Int, Int, Int}}()

    for line in lines
        nums = [parse(Int, num) for num in split(line, ',')]
        push!(cubes, Tuple(nums))
    end

    mins, maxes = zip([extrema([cube[axis] for cube in cubes]) for axis in 1:3]...)

    queue = Vector{Tuple{Int, Int, Int}}()
    visited = Set{Tuple{Int, Int, Int}}()
    faces = 0

    push!(queue, Tuple([min - 1 for min in mins]))

    while !isempty(queue)
        current = pop!(queue)

        if !(current in visited)

            neighbors = [
                (current[1] + 1, current[2], current[3]),
                (current[1] - 1, current[2], current[3]),
                (current[1], current[2] + 1, current[3]),
                (current[1], current[2] - 1, current[3]),
                (current[1], current[2], current[3] + 1),
                (current[1], current[2], current[3] - 1)
            ]

            for cube in neighbors
                if all([mins[axis] - 1 <= cube[axis] <= maxes[axis] + 1 for axis in 1:3]) && !(cube in visited)
                    if cube in cubes
                        faces += 1
                    else
                        push!(queue, cube)
                    end
                end
            end

            push!(visited, current)
        end
    end

    println(faces)
end

main()
