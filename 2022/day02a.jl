function main()
    lines = readlines(open("input.txt"))
    score = 0

    for line in lines
        if line[1] == 'A'
            if line[3] == 'Y'
                score += 6
            elseif line[3] == 'X'
                score += 3
            end
        elseif line[1] == 'B'
            if line[3] == 'Z'
                score += 6
            elseif line[3] == 'Y'
                score += 3
            end
        elseif line[1] == 'C'
            if line[3] == 'X'
                score += 6
            elseif line[3] == 'Z'
                score += 3
            end
        end

        if line[3] == 'X'
            score += 1
        elseif line[3] == 'Y'
            score += 2
        else
            score += 3
        end
    end

    print("$score\n")
end

main()
