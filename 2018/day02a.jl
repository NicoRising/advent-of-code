using DelimitedFiles

function main()
    ids = vec(readdlm("input.txt", '\n', String))

    two_count = 0
    three_count = 0

    for id in ids
        counts = Dict{Char, Int}()

        for letter in id
            count = get!(counts, letter, 0)
            counts[letter] = count + 1
        end

        contains_two = false
        contains_three = false

        for count in values(counts)
            if count == 2
                contains_two = true
            elseif count == 3
                contains_three = true
            end
        end

        two_count += contains_two
        three_count += contains_three
    end

    println(two_count * three_count)
end

main()