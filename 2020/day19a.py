import copy
import re

def condense(number, rules):
    rule_copy = copy.deepcopy(rules)
    if 'a' in rule_copy[number]:
        return 'a'
    if 'b' in rule_copy[number]:
        return 'b'
    for rule in re.findall('\d+', rule_copy[number]):
        rule_copy[number] = (' ' + rule_copy[number] + ' ').replace(' ' + rule + ' ', ' ' + condense(rule, rule_copy) + ' ')
    return '(' + rule_copy[number].replace(' ', '') + ')'

def main():
    lines = open('input.txt', 'r').read().splitlines()
    rules = {}
    for line in lines:
        if not line:
            break
        index = line.index(':')
        rules[line[:index]] = line[index + 2 :]
    rule = '^' + condense('0', rules) + '$'
    count = 0
    for line in lines[::-1]:
        if not line:
            break
        if re.findall(rule, line):
            count += 1
    print(count)
        
if __name__ == '__main__':
    main()