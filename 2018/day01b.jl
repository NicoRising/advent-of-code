using DelimitedFiles

function main()
    changes = readdlm("input.txt", '\n', Int64)

    frequency = 0
    visited = Set()
    index = 1

    while !in(frequency, visited)
        push!(visited, frequency)
        frequency += changes[index]
        index = index % length(changes) + 1
    end

    println(frequency)
end

main()