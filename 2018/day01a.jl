function main()
    frequency = 0

    open("input.txt") do file
        while !eof(file)
            frequency += parse(Int, readline(file))       
        end
    end

    println(frequency)
end

main()