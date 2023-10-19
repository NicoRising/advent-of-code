def main():
    lines = open('input.txt', 'r').read().splitlines()
    memory = {}
    for line in lines:
        if 'mask' in line:
            mask = line[line.index('=') + 2:]
        else:
            address = bin(int(line[line.index('[') + 1 : line.index(']')]))[2:]
            address = '0' * (36 - len(address)) + address
            for index in range(36):
                if mask[index] == '1' or mask[index] == 'X':
                    address = address[:index] + mask[index] + address[index + 1 :]
            addresses = set()
            count = address.count('X')
            if 2 ** count != 1:
                for float in range(2 ** count):
                    float = bin(float)[2:]
                    while count > len(float):
                        float = '0' + float
                    float_address = address
                    index = 0
                    for char in float:
                        index = float_address.index('X', index)
                        float_address = float_address[:index] + char + float_address[index + 1 :]
                    addresses.add(int(float_address, 2))
            else:
                addresses.add(int(address, 2))
            for address in addresses:
                value = bin(int(line[line.index('=') + 2:]))[2:]
                memory[address] = '0' * (36 - len(value)) + value
    total = 0
    for address in memory:
        total += int(memory[address], 2)
    print(total)
        
if __name__ == '__main__':
    main()