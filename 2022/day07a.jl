struct File
    name::String
    size::Int

    File(name::String, size::Int) = new(name, size)
end

struct Directory
    name::String
    parent::Union{Directory, Nothing}
    children::Vector{Directory}
    files::Vector{File}

    Directory(name::AbstractString, parent::Union{Directory, Nothing}) = new(name, parent, [], [])
end

function size_of(dir::Directory)::Int
    size = sum([file.size for file in dir.files])
    
    if !isempty(dir.children)
        size += sum([size_of(child) for child in dir.children])
    end
    
    return size
end

function main()
    terminal = read(open("input.txt"), String)[3:(end - 1)]
    
    root = Directory("/", nothing)
    working = root

    dirs = [root]

    for in_out in split(terminal, "\n\$ ")
        in_out = split(in_out, '\n')
        command = in_out[1][1:2]

        if command == "cd"
            dir_name = in_out[1][4:end]
            
            if dir_name == "/"
                working = root
            elseif dir_name == ".."
                working = working.parent
            else
                index = findfirst(child -> child.name == dir_name, working.children)
                working = working.children[index]
            end
        elseif command == "ls"
            for line in in_out[2:end]
                if length(line) >= 3 && line[1:3] == "dir"
                    dir_name = line[5:end]

                    if isnothing(findfirst(child -> child.name == dir_name, working.children))
                        new_dir = Directory(dir_name, working)

                        push!(working.children, new_dir)
                        push!(dirs, new_dir)
                    end
                else
                    size, file_name::String = split(line, " ")
                    size = parse(Int, size)

                    if isnothing(findfirst(child -> child.name == file_name, working.files))
                        push!(working.files, File(file_name, size))
                    end
                end
            end
        end
    end

    sizes = [size_of(dir) for dir in dirs]
    println(sum([size for size in sizes if size <= 100_000]))
end

main()
