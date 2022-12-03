function main()
    lines = readlines(open("input.txt"))
    score = 0

    for line in lines
        win_type = codepoint(line[3]) - 88
        opponent_move = codepoint(line[1]) - 65

        score += 3 * win_type
        score += mod(opponent_move + win_type - 1, 3) + 1
    end
    
    print("$score\n")
end

main()
