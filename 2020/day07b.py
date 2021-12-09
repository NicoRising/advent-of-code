import re

def count_nested_bags(bag, bag_dict):
    if bag in bag_dict:
        count = 0
        for innerBag in bag_dict[bag]:
            count += (count_nested_bags(innerBag[0], bag_dict) + 1) * innerBag[1]
        return count
    return 0

def main():
    lines = open('input.txt', 'r').read().splitlines()
    bag_dict = {}
    for rule in lines:
        if ' no ' not in rule:
            contains = []
            bag_index = rule.index(' bag')
            for count in range(rule.count(' bag') - 1):
                bag_index = rule.index(' bag', bag_index + 1)
                contains.append(rule[rule.rindex(' ', 0, rule.rindex(' ', 0, bag_index)) + 1 : bag_index])
            bag_dict[rule[:rule.index(' bag')]] = set(zip(contains, [int(digit) for digit in re.findall('\d', rule)]))
    print(count_nested_bags('shiny gold', bag_dict))
    
if __name__ == '__main__':
    main()