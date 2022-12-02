function main()
    lines = readlines(open("input.txt"))
    score = 0

    for line in lines
        my_move = convert(Int8, line[3] - 88)
        opponent_move = convert(Int8, line[1] - 65)

        score += my_move + 1
        score += 3 * mod(my_move - opponent_move + 1, 3)
    end
    
    print("$score\n")
end

main()
