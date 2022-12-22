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

    valve_list = [valve for valve in keys(valves) if valves[valve][1] != 0] # Make sure AA isn't in here if its useless

    queue = Vector{Tuple{Vector{String}, Vector{String}, Int, Int, Int}}()
    max_release = 0

    for valve_a in valve_list
        for valve_b in valve_list
            if valve_a != valve_b
                t_a = valves["AA"][2][valve_a]
                t_b = valves["AA"][2][valve_b]

                release = valves[valve_a][1] * (26 - t_a) + valves[valve_b][1] * (26 - t_b)
                push!(queue, ([valve_a], [valve_b], t_a, t_b, release))
            end
        end
    end

    pop!(valves, "AA")
    
    while !isempty(queue)
        path_a, path_b, t_a, t_b, release = pop!(queue)

        if release > max_release
            max_release = release
        end

        unvisited = setdiff(valve_list, path_a, path_b)

        for valve_a in unvisited
            for valve_b in unvisited
                if valve_a != valve_b
                    next_path_a = copy(path_a)
                    next_path_b = copy(path_b)

                    next_t_a = t_a + valves[path_a[end]][2][valve_a]
                    next_t_b = t_b + valves[path_b[end]][2][valve_b]

                    next_release = release

                    if next_t_a <= 26 && next_t_b <= 26
                        push!(next_path_a, valve_a)
                        push!(next_path_b, valve_b)
                        next_release += valves[valve_a][1] * (26 - next_t_a)
                        next_release += valves[valve_b][1] * (26 - next_t_b)

                        push!(queue, (next_path_a, next_path_b, next_t_a, next_t_b, next_release))
                    end
                end
            end
        end
    end

    println(max_release)
end

main()
