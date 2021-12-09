def main():
    lines = open('input.txt', 'r').read().splitlines()
    for test_index in range(len(lines)):
        test_input = lines.copy()
        if lines[test_index][:3] == 'jmp':
            test_input[test_index] = 'nop' + lines[test_index][3:]
        elif lines[test_index][:3] == 'nop':
            test_input[test_index] = 'jmp' + lines[test_index][3:]
        visited = set()
        accumulator = 0
        index = 0
        while index < len(test_input) and index not in visited:
            visited.add(index)
            op = test_input[index][:3]
            arg = int(test_input[index][4:])
            if op == 'acc':
                accumulator += arg
                index += 1
            elif op == 'jmp':
                index += arg
            else:
                index += 1
        if index >= len(test_input):
            break
    print(accumulator)
    
if __name__ == '__main__':
    main()