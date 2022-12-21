function main()
    lines = readlines(open("input.txt"))

    valves = Dict{String, Tuple{Int, Dict{String, Int}}}()

    for line in lines
        parsed = [part.match for part in eachmatch(r"[A-Z]{2}|\d+", line)]

        valve = parsed[1]
        flow = parse(UInt, parsed[2])
        goes_to = Dict(next_valve => 1 for next_valve in parsed[3:end])

        valves[valve] = (flow, goes_to)
    end

    for (valve, (flow, goes_to)) in valves # Turns graph into just useful valves to other useful valves
        if valve == "AA" || flow > 0
            queue = [(next, next_dist) for (next, next_dist) in goes_to]
            index = 1

            while index <= length(queue)
                current, t = queue[index]
                index += 1
                
                for (next, next_t) in valves[current][2]
                    if !(next in keys(goes_to) && t + next_t >= goes_to[next]) && next != valve
                        push!(goes_to, next => t + next_t)

                        insert_index = index

                        while insert_index <= length(queue) && queue[insert_index][2] < t + next_t
                            insert_index += 1
                        end

                        insert!(queue, insert_index, (next, t + next_t))
                    end
                end
            end
        end
    end

    for (valve, (_, goes_to)) in valves
        if valve != "AA" && valves[valve][1] == 0
            pop!(valves, valve)
        else
            for next in keys(goes_to)
                if !(next in keys(valves)) || valves[next][1] == 0
                    pop!(goes_to, next)
                else
                    goes_to[next] += 1
                end
            end
        end
    end

    queue = [([next], next_t, valves[next][1] * (30 - next_t)) for (next, next_t) in valves["AA"][2]]
    max_release = 0

    pop!(valves, "AA")

    while !isempty(queue)
        path, t, release = pop!(queue)

        if release > max_release
            max_release = release
        end

        for valve in keys(valves)
            if !(valve in path)
                next_t = t + valves[path[end]][2][valve] 

                if next_t <= 30
                    next_release = release + valves[valve][1] * (30 - next_t)
                    push!(queue, (vcat(path, valve), next_t, next_release))
                end
            end
        end
    end

    println(max_release)
end

main()
