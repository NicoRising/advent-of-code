import copy
import re

def main():
    lines = open('input.txt', 'r').read().splitlines()
    rules = {}
    for line in lines:
        if not line:
            break
        index = line.index(':')
        if line[:index] == '8':
            rules[line[:index]] = ' 42 | 42 8 '
        elif line[:index] == '11':
            rules[line[:index]] = ' 42 31 | 42 42 31 31 | 42 42 42 31 31 31 | 42 42 42 42 31 31 31 31'
        elif 'a' in line[index + 2 :]:
            a = line[:index]
        elif 'b' in line[index + 2 :]:
            b = line[:index]
        else:
            rules[line[:index]] = ' ' + line[index + 2 :] + ' '
    compressed = set()
    for number in rules:
        while re.findall(' ' + str(a) + ' ', rules[number]):
            rules[number] = rules[number].replace(' ' + a + ' ', ' a ')
        while re.findall(' ' + str(b) + ' ', rules[number]):
            rules[number] = rules[number].replace(' ' + b + ' ', ' b ')
        if not re.findall('\d', rules[number]):
            compressed.add(number)
    for rule in rules:
        if ' ' + rule + ' ' in rules[rule]:
            index = rules[rule].index(' ' + rule + ' ')
            rules[rule] = rules[rule][:index + 1] + ' + ' + rules[rule][index + len(rule) + 1:]
    while re.findall('\d', rules['0']):
        prevRules = copy.deepcopy(rules)
        nextCompressed = set()
        for replace in compressed:
            for number in rules:
                while re.findall(' ' + replace + ' ', rules[number]):
                    rules[number] = (' ' + rules[number] + ' ').replace(' ' + replace + ' ', ' (' + rules[replace] + ') ')
                if not re.findall('\d', rules[number]):
                    nextCompressed.add(number)
        if compressed == nextCompressed:
            break
        compressed = nextCompressed
    rule = '^' + rules['0'].replace(' ', '') + '$'
    count = 0
    for line in lines[::-1]:
        if not line:
            break
        if re.findall(rule, line):  
            count += 1
    print(count)
        
if __name__ == '__main__':
    main()