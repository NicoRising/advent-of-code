function main()
    lines = readlines(open("input.txt"))
    cubes = Set{Tuple{Int, Int, Int}}()

    for line in lines
        nums = [parse(Int, num) for num in split(line, ',')]
        push!(cubes, Tuple(nums))
    end

    faces = 0

    for cube in cubes
        sides = [
            (cube[1] + 1, cube[2], cube[3]) in cubes,
            (cube[1] - 1, cube[2], cube[3]) in cubes,
            (cube[1], cube[2] + 1, cube[3]) in cubes,
            (cube[1], cube[2] - 1, cube[3]) in cubes,
            (cube[1], cube[2], cube[3] + 1) in cubes,
            (cube[1], cube[2], cube[3] - 1) in cubes
        ]
        
        faces += 6 - sum(sides)
    end

    println(faces)
end

main()
