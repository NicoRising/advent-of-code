function calc_pressure(path, valves)
    total = 0
    t = 0

    for step in 2:length(path)
        if path[step] == path[step - 1]
            t += 1
            total += valves[path[step]][1] * (30 - t)
        else
            t += valves[path[step - 1]][2][path[step]]
        end
    end

    return total
end

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

    aa_is_zero = false

    for (valve_a, (flow, goes_to_a)) in valves # Turns the graph into a weighted one with just useful valves
        if flow == 0
            if valve_a != "AA" # Keep AA around as a starting point
                pop!(valves, valve_a)
            else
                aa_is_zero = true
            end
            
            for (valve_b, (_, goes_to_b)) in valves
                for (valve_c, dist_a) in goes_to_b
                    if valve_c == valve_a
                        for (valve_d, dist_b) in goes_to_a
                            if valve_d != valve_b # Don't let valves loop back on themselves
                                if valve_d in keys(goes_to_b)
                                    goes_to_b[valve_d] = min(goes_to_b[valve_d], dist_a + dist_b)
                                else
                                    push!(goes_to_b, valve_d => dist_a + dist_b)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    for (_, goes_to) in values(valves) # Remove all the useless valves from the tunnel lists
        for valve in keys(goes_to)
            if !(valve in keys(valves)) || aa_is_zero && valve == "AA"
                pop!(goes_to, valve)
            end
        end
    end

    paths = Set{Vector{String}}()
    queue = Vector{Tuple{Vector{String}, Int}}()

    push!(queue, (["AA"], 0))

    while !isempty(queue)
        path, t = pop!(queue)
        
        if !(path in paths)
            for (valve, travel) in valves[path[end]][2]
                if t + travel <= 30
                    can_travel = true
                    visited = false

                    for step in 1:length(path)
                        if step != length(path) && path[step] == valve
                            can_travel = false
                            visited = true
                        end

                        if !can_travel && visited && step >= 2 && path[step] == path[step - 1]
                            can_travel = true
                        end
                    end

                    if can_travel
                        push!(queue, (vcat(path, valve), t + travel))
                    end
                end
            end
            
            can_open = (aa_is_zero || path[end] != "AA") && t < 30

            for step in 2:length(path)
                if !can_open || path[step] == path[end] && path[step] == path[step - 1]
                    can_open = false
                    break
                end
            end

            if can_open
                push!(queue, (vcat(path, [path[end]]), t + 1))
            end

            for step in length(path):-1:2
                if path[step] == path[step - 1]
                    push!(paths, path[1:step]) # Remove irrelevent part of path after opening final valve
                    break
                end
            end
        end
    end

    println(maximum([calc_pressure(path, valves) for path in paths]))
end

main()
