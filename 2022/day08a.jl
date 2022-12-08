function main()
    lines = readlines(open("input.txt"))

    width = length(lines[1])
    height = length(lines)

    trees = Array{UInt8}(undef, width, height)
    
    for (y, line) in enumerate(lines)
        for (x, chr) in enumerate(line)
            trees[y, x] = parse(UInt8, chr)
        end
    end

    count = 0

    for (x, col) in enumerate(eachcol(trees))
        for (y, row) in enumerate(eachrow(trees))
            right = row[(x + 1):end]
            down = col[(y + 1):end]
            left = row[(x - 1):-1:1]
            up = col[(y - 1):-1:1]

            tallest(tree, others) = all([tree > other for other in others])

            if any([tallest(trees[y, x], side) for side in [right, down, left, up]])
                count += 1
            end
        end
    end

    println(count)
end

main()
