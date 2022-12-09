function main()
    moves = readlines(open("input.txt"))

    hx = 0
    hy = 0

    tx = 0
    ty = 0

    visited = Set{Tuple{Int, Int}}()

    for move in moves
        dir = move[1]
        dist = parse(Int, move[3:end])

        for _ in 1:dist
            if dir == 'R'
                hx += 1
            elseif dir == 'D'
                hy += 1
            elseif dir == 'L'
                hx -= 1
            elseif dir == 'U'
                hy -= 1
            end

            if abs(hx - tx) > 1 || abs(hy - ty) > 1
                if hx - tx > 0
                    tx += 1
                elseif hx - tx < 0
                    tx -= 1
                end

                if hy - ty > 0
                    ty += 1
                elseif hy - ty < 0
                    ty -= 1
                end
            end

            push!(visited, (tx, ty))
        end
    end

    println(length(visited))
end

main()
