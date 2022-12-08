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

    max_scenic = 0

    for (x, col) in enumerate(eachcol(trees))
        for (y, row) in enumerate(eachrow(trees))
            right = row[(x + 1):end]
            down = col[(y + 1):end]
            left = row[(x - 1):-1:1]
            up = col[(y - 1):-1:1]

            scenic = 1

            for side in [right, down, left, up]
                view_dist = 0

                for tree in side
                    if trees[y, x] > tree
                        view_dist += 1
                    else
                        view_dist += 1 # Count tree that is blocking your view
                        break
                    end
                end

                scenic *= view_dist
            end

            max_scenic = max(scenic, max_scenic)
        end
    end

    println(max_scenic)
end

main()
