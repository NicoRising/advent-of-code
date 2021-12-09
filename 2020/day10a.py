def main():
    lines = open('input.txt', 'r').read().splitlines()
    adapters = [int(i) for i in lines]
    adapters.sort()
    one_count = 1
    three_count = 1
    for index in range(len(adapters) - 1):
        if adapters[index + 1] - adapters[index] == 1:
            one_count += 1
        elif adapters[index + 1] - adapters[index] == 3:
            three_count += 1
    print(one_count * three_count)
    
if __name__ == '__main__':
    main()