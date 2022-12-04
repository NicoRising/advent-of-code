function main()
    lines = readlines(open("input.txt"))

    max_cal = 0
    sum_cal = 0

    for line in lines
        if line != ""
            sum_cal += parse(Int, line)
        else
            if sum_cal > max_cal
                max_cal = sum_cal
            end

            sum_cal = 0
        end
    end

    print("$max_cal\n")
end

main()
