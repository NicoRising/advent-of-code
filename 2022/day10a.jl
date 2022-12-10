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

    cpu = zeros(Int, 220)
    cpu[1] = 1

    pending_index = 1 # A bit more efficient

    for cycle in 2:length(cpu)
        cpu[cycle] = cpu[cycle - 1]

        if pending_index <= length(pending)
            pending[pending_index][1] -= 1

            if pending[pending_index][1] == 0
                cpu[cycle] += pending[pending_index][2]
                pending_index += 1
            end
        end
    end

    signal_strengths = [cycle * cpu[cycle] for cycle in 20:40:220]

    println(sum(signal_strengths))
end

main()
