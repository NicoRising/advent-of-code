import re

def main():
    lines = open('input.txt','r').read().splitlines()
    fields = {}
    for line in lines:
        if not line:
            break
        numbers = [int(i) for i in re.findall('\d+',line)]
        fields[line[:line.index(':')]] = (range(numbers[0],numbers[1] + 1),range(numbers[2],numbers[3] + 1))
    tickets = set()
    for line in lines[::-1]:
        if line == 'nearby tickets:':
            break
        tickets.add(tuple([int(i) for i in line.split(',')]))
    discard = set()
    for ticket in tickets:
        for field in ticket:
            invalid = True
            for ranges in fields.values():
                if field in ranges[0] or field in ranges[1]:
                    invalid = False
                    break
            if invalid:
                discard.add(ticket)
    tickets = tickets - discard
    possible = {}
    for info in range(len(fields)):
        for field in fields:
            is_possible = True
            for ticket in tickets:
                if ticket[info] not in fields[field][0] and ticket[info] not in fields[field][1]:
                    is_possible = False
                    break
            if is_possible:
                if field in possible:
                    possible[field].append(info)
                else:
                    possible[field] = [info]
    order = [-1 for i in range(len(fields))]
    while -1 in order:
        for field in possible:
            if len(possible[field]) == 1:
                pos = possible[field][0]
                order[pos] = field
                for field in possible:
                    if pos in possible[field]:
                        possible[field].remove(pos)
    ticket = [int(i) for i in lines[lines.index('your ticket:') + 1].split(',')]
    departures = 1
    for field in enumerate(order):
    if 'departure' in field[1]:
        departures *= ticket[field[0]]
    print(departures)
        
if __name__ == '__main__':
    main()