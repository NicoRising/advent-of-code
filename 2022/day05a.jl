function main()
    crates_str, moves_str = split(read(open("input.txt"), String), "\n\n")
    
    crates_lines = reverse(split(crates_str, "\n"))
    moves_lines = split(moves_str, "\n")[1:(end - 1)]

    crates = [[] for _ in 1:fld(length(crates_lines[1]), 3)]

    for line in crates_lines[2:end]
        for (crate_index, line_index) in enumerate(2:4:length(line))
            if line[line_index] != ' '
                push!(crates[crate_index], line[line_index])
            end
        end
    end
    
    for move in moves_lines
        nums = [parse(Int, num.match) for num in eachmatch(r"\d+", move)]
        
        for _ in 1:nums[1]
            push!(crates[nums[3]], pop!(crates[nums[2]]))
        end
    end
        
    tops = foldl(*, [last(stack) for stack in crates if !isempty(stack)])
    println(tops)
end

main()
