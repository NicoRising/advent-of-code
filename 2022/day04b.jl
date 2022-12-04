function main()
    pairs = readlines(open("input.txt"))
    total = 0

    for pair in pairs
        nums = [parse(Int, num.match) for num in eachmatch(r"\d+", pair)]
        
        range1 = nums[1]:nums[2]
        range2 = nums[3]:nums[4]

        if !isdisjoint(range1, range2)
            total += 1
        end
    end

    print("$total\n")
end

main()
