def main():
    lines = open('input.txt', 'r').read().splitlines()
    x = 0
    count = 0
    for y in lines:
        if y[x] == '#':
            count += 1
        x = (x + 3) % len(lines[0])
    print(count)
    
if __name__ == '__main__':
    main()