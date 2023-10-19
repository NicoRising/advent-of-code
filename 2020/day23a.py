from collections import deque

def main():
    lines = open('Input.txt', 'r').read().splitlines()
    cups = deque([int(i) for i in lines[0]])
    cup_length = len(cups)
    picked_length = 3
    cups.rotate(len(cups) - picked_length - 1)
    t = 0
    while t < 100:
        current = cups[ - 4]
        picked = []
        for i in range(picked_length):
            picked.append(cups.pop())
        picked = picked[:: -1]
        destination = current - 1
        while destination in picked or destination < 1:
            destination -= 1
            if destination < 1:
                if cup_length not in picked:
                    destination = cup_length
                elif cup_length - 1 not in picked:
                    destination = cup_length - 1
                elif cup_length - 2 not in picked:
                    destination = cup_length - 2
                else:
                    destination = cup_length - 3
        rot = cup_length - picked_length - cups.index(destination) - 1
        cups.rotate(rot)
        cups.extend(picked)
        cups.rotate( - rot - picked_length - 1)
        t += 1
    cups = list(cups)
    target = cups.index(1)
    output = ''
    for cup in cups[target + 1:] + cups[: target]:
        output += str(cup)
    print(output)
    
if __name__ == '__main__':
    main()