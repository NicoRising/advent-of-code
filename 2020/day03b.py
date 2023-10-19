def main():
    lines = open('input.txt', 'r').read().splitlines()
    test_slope = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    total = 1
    for slope in test_slope:
        x = 0
        y = 0
        count = 0
        while y < len(lines):
            if lines[y][x] == '#':
                count += 1
            x = (x + slope[0]) % len(lines[0])
            y += slope[1]
        total *= count
    print(total)
    
if __name__ == '__main__':
    main()