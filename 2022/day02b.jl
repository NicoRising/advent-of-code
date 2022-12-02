function main()
    lines = readlines(open("input.txt"))
    score = 0

    for line in lines
        if line[1] == 'A'
            if line[3] == 'X'
                score += 3
            elseif line[3] == 'Y'
                score += 1
            else
                score += 2
            end
        elseif line[1] == 'B'
            if line[3] == 'Z'
                score += 3
            elseif line[3] == 'Y'
                score += 2
            else
                score += 1
            end
        elseif line[1] == 'C'
            if line[3] == 'X'
                score += 2
            elseif line[3] == 'Z'
                score += 1
            else
                score += 3
            end
        end

        if line[3] == 'X'
            score += 0
        elseif line[3] == 'Y'
            score += 3
        else
            score += 6
        end
    end

    print("$score\n")
end

main()
