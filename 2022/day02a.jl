function main()
    lines = readlines(open("input.txt"))
    score = 0

    for line in lines
        my_move = codepoint(line[3]) - 88
        opponent_move = codepoint(line[1]) - 65

        score += my_move + 1
        score += 3 * mod(my_move - opponent_move + 1, 3)
    end
    
    println(score)
end

main()
