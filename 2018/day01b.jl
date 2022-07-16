using DelimitedFiles

function main()
    changes = vec(readdlm("input.txt", '\n', Int))

    frequency = 0
    visited = Set{Int}()
    index = 1

    while !in(frequency, visited)
        push!(visited, frequency)
        frequency += changes[index]
        index = index % length(changes) + 1
    end

    println(frequency)
end

main()