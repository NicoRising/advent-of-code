function main()
    ops = readlines(open("input.txt"))
    
    pending = []

    for op in ops
        if op[1:4] == "noop"
            push!(pending, [1, 0])
        elseif op[1:4] == "addx"
            push!(pending, [2, parse(Int, op[6:end])])
        end
    end

    cpu = zeros(Int, 240)
    pending_index = 1 # A bit more efficient
    screen = ""

    for cycle in 1:length(cpu)
        if cycle == 1
            cpu[cycle] = 1
        else
            cpu[cycle] = cpu[cycle - 1]

            if pending_index <= length(pending)
                pending[pending_index][1] -= 1

                if pending[pending_index][1] == 0
                    cpu[cycle] += pending[pending_index][2]
                    pending_index += 1
                end
            end
        end

        if cpu[cycle] - 1 <= (cycle - 1) % 40 <= cpu[cycle] + 1
            screen *= '#'
        else
            screen *= '.'
        end

        if cycle % 40 == 0
            screen *= '\n'
        end
    end

    print(screen)
end

main()
