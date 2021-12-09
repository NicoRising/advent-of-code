def main():
    lines = open('input.txt','r').read().splitlines()
    memory = []
    for line in lines:
        if 'mask' in line:
            mask = line[line.index('=') + 2 :]
        else:
            address = int(line[line.index('[') + 1 : line.index(']')])
            value = bin(int(line[line.index('=') + 2 :]))[2:]
            while address >= len(memory):
                memory.append('0' * 36)
            memory[address] = '0' * (36 - len(value)) + value
            for index in range(36):
                if mask[index] != 'X':
                    memory[address] = memory[address][:index] + mask[index] + memory[address][index + 1 :]
    total = 0
    for address in memory:
    total += int(address, 2)
    print(total)
        
if __name__ == '__main__':
    main()