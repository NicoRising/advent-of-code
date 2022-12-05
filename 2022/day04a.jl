function main()
    pairs = readlines(open("input.txt"))
    total = 0

    for pair in pairs
        nums = [parse(Int, num.match) for num in eachmatch(r"\d+", pair)]
        
        range1 = nums[1]:nums[2]
        range2 = nums[3]:nums[4]

        if issubset(range1, range2) || issubset(range2, range1)
            total += 1
        end
    end

    println(total)
end

main()
