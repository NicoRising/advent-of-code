def main():
    lines = open('input.txt', 'r').read().splitlines()
    lines = [int(i) for i in lines]
    sum_values = lines[:25]
    for value in lines[25:]:
        found = None
        for i in range(25):
            for e in range(25):
                if not found and i != e and sum_values[i] + sum_values[e] == value:
                    sum_values = sum_values[1:] + [value]
                    found = value
        if not found:
            print(value)
            break

if __name__ == '__main__':
    main()