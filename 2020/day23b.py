def main():
    lines = open('input.txt', 'r').read().splitlines()
    lines = [int(i) for i in lines[0]]
    add = [i + len(lines) + 1 for i in range(1000000 - len(lines))]
    lines = lines + add
    lines = [i - 1 for i in lines]
    cups = [0 for i in range(len(lines))]
    for i in range(len(lines) - 1):
        cups[lines[i]] = lines[i + 1]
    cups[lines[len(lines) - 1]] = lines[0]
    current = lines[0]
    t = 0
    while t < 10000000:
        a = cups[current]
        b = cups[a]
        c = cups[b]
        destination = current - 1
        while destination == a or destination == b or destination == c or destination < 0:
            destination -= 1
            if destination < 0:
                destination = len(cups) - 1
        cups[current] = cups[c]
        cups[c] = cups[destination]
        cups[destination] = a
        current = cups[current]
        t += 1
    print((cups[0] + 1) * (cups[cups[0]] + 1))
    
if __name__ == '__main__':
    main()