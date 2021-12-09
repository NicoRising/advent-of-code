import re

def main():
    lines = open('input.txt', 'r').read().splitlines()
    range_set = set()
    for line in lines:
        if not line:
            break
        numbers = [int(i) for i in re.findall('\d+',line)]
        range_set.add((range(numbers[0], numbers[1] + 1), range(numbers[2], numbers[3] + 1)))
    tickets = set()
    for line in lines[::-1]:
        if line == 'nearby tickets:':
            break
        tickets.add(tuple([int(i) for i in line.split(',')]))
    error_rate = 0
    for ticket in tickets:
        for field in ticket:
            invalid = True
            for ranges in range_set:
                if field in ranges[0] or field in ranges[1]:
                    invalid = False
                    break
            if invalid:
                error_rate += field
    print(error_rate)
        
if __name__ == '__main__':
    main()