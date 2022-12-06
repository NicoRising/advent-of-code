function main()
    signal = read(open("input.txt"), String)
    
    for index in 14:length(signal)
        if allunique(signal[(index - 13):index])
            println(index)
            break;
        end
    end
end

main()
