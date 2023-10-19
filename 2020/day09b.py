def main():
    lines = open('input.txt', 'r').read().splitlines()
    lines = [int(i) for i in lines]
    sumValues = lines[:25]
    for value in lines[25:]:
        found = None
        for i in range(25):
            for e in range(25):
                if not found and i != e and sumValues[i] + sumValues[e] == value:
                    sumValues = sumValues[1:] + [value]
                    found = value
        if not found:
            target = value
            break
    for length in range(2, len(lines)):
        for index in range(len(lines) - length):
            test = lines[index:index + length]
            if sum(test) == target:
                print(min(test) + max(test))
                quit()
                
if __name__ == '__main__':
    main()