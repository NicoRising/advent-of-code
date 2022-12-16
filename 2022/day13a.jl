function isless(a::Int, b::Int)::Int
    if a < b
        return 1
    elseif a > b
        return -1
    else
        return 0
    end
end

function isless(a::Vector, b::Vector)::Int
    for (i, e) in zip(a, b)
        less_val = isless(i, e)
        
        if less_val != 0
            return less_val
        end
    end

    if length(a) < length(b)
        return 1
    elseif length(a) > length(b)
        return -1
    else
        return 0
    end
end

function isless(a::Int, b::Vector)::Int
    return isless([a], b)
end

function isless(a::Vector, b::Int)::Int
    return isless(a, [b])
end

function main()
    lines = readlines(open("input.txt"))
    pairs = [lines[index:(index + 1)] for index in 1:3:length(lines)]

    total = 0

    for (index, pair) in enumerate(pairs)
        a = eval(Meta.parse(pair[1]))
        b = eval(Meta.parse(pair[2]))

        if isless(a, b) == 1
            total += index
        end
    end

    println(total)
end

main()
