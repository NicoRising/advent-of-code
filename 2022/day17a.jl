function main()
    inputs = read(open("input.txt"), String)[1:(end - 1)] # Remove newline

    shapes = Vector{Vector{Bool}}[
        [
            [1, 1, 1, 1]
        ],
        [
            [0, 1, 0],
            [1, 1, 1],
            [0, 1, 0]
        ],
        [
            [0, 0, 1],
            [0, 0, 1],
            [1, 1, 1]
        ],
        [
            [1],
            [1],
            [1],
            [1]
        ],
        [
            [1, 1],
            [1, 1]
        ]
    ]

    grid = ones(Bool, 7, 0)
    shape_index = 0
    input = 1

    while shape_index < 2022
        shape = shapes[shape_index % length(shapes) + 1]
        rocks = Vector{Vector{Int}}()

        for y in 1:length(shape)
            for x in 1:length(shape[1])
                if shape[y][x]
                    push!(rocks, [x + 2, length(shape) - y + size(grid)[2] + 4]) # Make sure to flip vertically
                end
            end
        end

        can_fall = true

        while can_fall
            slide = inputs[input] == '>' ? 1 : -1

            for rock in rocks
                if inputs[input] == '>' && rock[1] + 1 > size(grid)[1]
                    slide = 0
                elseif inputs[input] == '>' && 1 <= rock[2] <= size(grid)[2] && grid[rock[1] + 1, rock[2]]
                    slide = 0
                elseif inputs[input] == '<' && rock[1] - 1 < 1
                    slide = 0
                elseif inputs[input] == '<' && 1 <= rock[2] <= size(grid)[2] && grid[rock[1] - 1, rock[2]]
                    slide = 0
                end
            end

            for rock in rocks
                rock[1] += slide
            end

            input += 1

            if input > length(inputs)
                input = 1
            end

            for rock in rocks
                if rock[2] - 1 < 1 || rock[2] - 1 <= size(grid)[2] && grid[rock[1], rock[2] - 1]
                    can_fall = false
                end
            end

            if can_fall
                for rock in rocks
                    rock[2] -= 1
                end
            end
        end

        max_y = maximum([rock[2] for rock in rocks])

        if max_y > size(grid)[2]
            grid = hcat(grid, zeros(Bool, 7, max_y - size(grid)[2]))
        end

        for rock in rocks
            grid[rock...] = true
        end

        shape_index += 1
    end

    println(size(grid)[2])
end

main()
