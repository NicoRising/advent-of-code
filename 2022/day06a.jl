function main()
    signal = read(open("input.txt"), String)
    
    for index in 4:length(signal)
        if allunique(signal[(index - 3):index])
            println(index)
            break;
        end
    end
end

main()
