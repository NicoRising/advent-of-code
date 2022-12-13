function main()
    lines = readlines(open("input.txt"))[end:-1:1]
    monkies = []

    while !isempty(lines)
        pop!(lines)

        starting = [parse(Int, num.match) for num in eachmatch(r"\d+", pop!(lines))]

        op_string = pop!(lines)[24:end]
        
        if op_string == "* old"
            operation = old -> old ^ 2
        elseif op_string[1] == '+'
            operation = old -> old + parse(Int, op_string[3:end])
        elseif op_string[1] == '*'
            operation = old -> old * parse(Int, op_string[3:end])
        end
        
        test = parse(Int, pop!(lines)[21:end])
        if_true = parse(Int, pop!(lines)[30:end])
        if_false = parse(Int, pop!(lines)[31:end])

        if !isempty(lines)
            pop!(lines)
        end

        push!(monkies, (starting, operation, test, if_true, if_false))        
    end

    activity = zeros(Int, length(monkies))

    for _ in 1:20
        for (index, monkey) in enumerate(monkies)
            while !isempty(monkey[1])
                worry = popfirst!(monkey[1])
                worry = monkey[2](worry)
                worry = fld(worry, 3)

                if worry % monkey[3] == 0
                    push!(monkies[monkey[4] + 1][1], worry)
                else
                    push!(monkies[monkey[5] + 1][1], worry)
                end

                activity[index] += 1
            end
        end
    end

    sort!(activity, rev = true)

    println(activity[1] * activity[2])
end

main()
