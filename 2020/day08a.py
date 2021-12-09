def main():
    lines = open('input.txt', 'r').read().splitlines()
    visited = set()
    accumulator = 0
    index = 0
    while index not in visited:
        visited.add(index)
        op = lines[index][:3]
        arg = int(lines[index][4:])
        if op == 'acc':
            accumulator += arg
            index += 1
        elif op == 'jmp':
            index += arg
        else:
            index += 1
    print(accumulator)
    
if __name__ == '__main__':
    main()