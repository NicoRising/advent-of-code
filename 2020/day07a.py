def main():
    lines = open('input.txt', 'r').read().splitlines()
    bag_dict = {}
    for rule in lines:
        if ' no ' not in rule:
            bag_index = rule.index(' bag')
            for count in range(rule.count(' bag') - 1):
                bag_index = rule.index(' bag', bag_index + 1)
                bag = rule[rule.rindex(' ', 0, rule.rindex(' ', 0, bag_index)) + 1 : bag_index]
                if bag not in bag_dict:
                    bag_dict[bag] = set()
                bag_dict[bag].add(rule[:rule.index(' bag')])
    can_contain = bag_dict['shiny gold']
    complete = False
    while not complete:
        complete_check = can_contain.copy()
        for contains in can_contain:
            if contains in bag_dict:
                can_contain = can_contain | bag_dict[contains]
        if complete_check == can_contain:
            complete = True
    print(len(can_contain))
    
if __name__ == '__main__':
    main()