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

    divider_a = 1
    divider_b = 1

    for packet in Iterators.flatten(pairs)
        packet = eval(Meta.parse(packet))

        if isless(packet, [[2]]) == 1
            divider_a += 1
        end

        if isless(packet, [[6]]) == 1
            divider_b += 1
        end
    end

    if divider_a > divider_b # Account for other packet in the list
        divider_a += 1
    else
        divider_b += 1
    end

    println(divider_a * divider_b)
end

main()
