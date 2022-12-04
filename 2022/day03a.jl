function priority(item)
    ascii = convert(Int, item)
    return ascii - (ascii < 97 ? 38 : 96)
end

function main()
    rucksacks = readlines(open("input.txt"))
    total = 0

    for rucksack in rucksacks
        half = fld(length(rucksack), 2)

        for item in rucksack[1:half]
            if contains(rucksack[(half + 1):end], item)
                total += priority(item)
                break
            end
        end
    end

    print("$total\n")
end

main()
