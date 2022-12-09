function main()
    moves = readlines(open("input.txt"))

    xs = [0 for _ in 1:10]
    ys = [0 for _ in 1:10]

    visited = Set{Tuple{Int, Int}}()

    for move in moves
        dir = move[1]
        dist = parse(Int, move[3:end])

        for _ in 1:dist
            if dir == 'R'
                xs[1] += 1
            elseif dir == 'D'
                ys[1] += 1
            elseif dir == 'L'
                xs[1] -= 1
            elseif dir == 'U'
                ys[1] -= 1
            end

            for knot in 2:10
                if abs(xs[knot - 1] - xs[knot]) > 1 || abs(ys[knot - 1] - ys[knot]) > 1
                    if xs[knot - 1] - xs[knot] > 0
                        xs[knot] += 1
                    elseif xs[knot - 1] - xs[knot] < 0
                        xs[knot] -= 1
                    end

                    if ys[knot - 1] - ys[knot] > 0
                        ys[knot] += 1
                    elseif ys[knot - 1] - ys[knot] < 0
                        ys[knot] -= 1
                    end
                end
            end

            push!(visited, (xs[10], ys[10]))
        end
    end

    println(length(visited))
end

main()
