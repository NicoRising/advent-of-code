function main()
    lines = readlines(open("input.txt"))

    max_cals = [0, 0, 0]
    sum_cal = 0

    for line in lines
        if line != ""
            sum_cal += parse(Int64, line)
        else
            if sum_cal > max_cals[1]
                max_cals[1] = sum_cal
                max_cals = sort(max_cals)
            end

            sum_cal = 0
        end
    end

    total = sum(max_cals)
    print("$total\n")
end

main()
