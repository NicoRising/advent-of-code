function show(grid)
    out = ""

    for y in size(grid)[2]:-1:1
        for x in 1:size(grid)[1]
            if grid[x, y]
                out *= '#'
            else
                out *= '.'
            end
        end
        out *= '\n'
    end

    println(out)
end

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
    shape_index = 1
    input = 1

    height = 0
    heights = Vector{Int}()

    while shape_index <= 1_000_000_000_000
        shape = shapes[(shape_index - 1) % length(shapes) + 1]
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
            input = (input - 1) % length(inputs) + 1
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
            if height != 0
                height += max_y - size(grid)[2]
            end

            grid = hcat(grid, zeros(Bool, 7, max_y - size(grid)[2]))
        end

        for rock in rocks
            grid[rock...] = true
        end

        if height == 0
            push!(heights, size(grid)[2])

            for chunk in 1:fld(shape_index - 1, 3)
                chunk_heights = [heights[end - chunk * (i - 1)] - heights[end - chunk * i] for i in 1:3]

                if allequal(chunk_heights)
                    chunk_height = chunk_heights[1]
                    compare_grids = [grid[:, (end - chunk_height * i + 1):(end - chunk_height * (i - 1))] for i in 1:3]

                    if chunk_height > 0 && allequal(compare_grids)
                        steps_before_repeat = shape_index - chunk * 3
                        height_before_repeat = heights[steps_before_repeat + 1] 
                        loops = fld(1_000_000_000_000 - steps_before_repeat, chunk)

                        height = height_before_repeat + loops * chunk_height - 1
                        shape_index = steps_before_repeat + loops * chunk
                    end
                end
            end
        end

        shape_index += 1
    end

    println(height)
end

main()
