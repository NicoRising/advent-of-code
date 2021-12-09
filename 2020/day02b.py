def main():
    lines = open('input.txt', 'r').read().splitlines()
    correct = 0
    for line in lines:
        a = int(line[:line.index('-')]) - 1
        b = int(line[line.index('-') + 1 : line.index(' ')]) - 1
        target = line[line.index(' ') + 1]
        password = line[line.index(':') + 2 :]
        if password[a] != password[b] == target or password[b] != password[a] == target:
            correct += 1
    print(correct)

if __name__ == '__main__':
    main()