frequency = 0

open("input.txt") do file
    while !eof(file)
        global frequency += parse(Int, readline(file))       
    end
end

println(frequency)