function size_of(dir)::Int
    size = sum([file[2]::Int for file in dir[4]])
    size += sum([size_of(child) for child in dir[3]])
    
    return size
end

function main()
    terminal = read(open("input.txt"), String)[3:(end - 1)]
    
    root = ["/", nothing, [], []]
    root[2] = root

    working = root
    dirs = [root]

    for in_out in split(terminal, "\n\$ ")
        in_out = split(in_out, '\n')
        command = in_out[1][1:2]

        if command == "cd"
            dir = in_out[1][4:end]
            
            if dir == "/"
                working = root
            elseif dir == ".."
                working = working[2]
            else
                index = findfirst(child -> child[1] == dir, working[3])
                working = working[3][index]
            end
        elseif command == "ls"
            for line in in_out[2:end]
                if length(line) >= 3 && line[1:3] == "dir"
                    dir = line[5:end]

                    if isnothing(findfirst(child -> child[1] == dir, working[3]))
                        new_dir = [dir, working, [], []]
                        push!(working[3], new_dir)
                        push!(dirs, new_dir)
                    end
                else
                    size, file = split(line, " ")

                    if isnothing(findfirst(child -> child[1] == file, working[4]))
                        push!(working[4], (file, parse(Int, size)))
                    end
                end
            end
        end
    end

    sizes = []

    for dir in dirs
        push!(sizes, size_of(dir))
    end

    free_up = sizes[1] - (70_000_000 - 30_000_000)
    min = sizes[1]

    for size in sizes
        if size <= min && size >= free_up
            min = size
        end
    end

    println(min)
end

main()
