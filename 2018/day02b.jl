using DelimitedFiles

function main()
    ids = vec(readdlm("input.txt", '\n', String))
    
    for id_a in ids, id_b in ids
        diff = -1

        for i in 1:length(id_a)
            if id_a[i] != id_b[i]
                if diff == -1
                    diff = i
                else
                    diff = -1
                    break
                end
            end
        end

        if diff != -1
            println(id_a[1:(diff - 1)] * id_a[(diff + 1):end])
            break
        end
    end
end

main()