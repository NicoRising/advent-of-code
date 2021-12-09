def main():
    lines = open('input.txt', 'r').read().splitlines()
    adapters = [int(i) for i in lines]
    adapters.append(0)
    adapters.append(max(adapters) + 3)
    adapters.sort()
    adapter_groups = []
    last_index = 0
    for index in range(len(adapters) - 1):
        if adapters[index + 1] - adapters[index] == 3:
            if len(adapters[last_index:index + 1]) > 2:
                adapter_groups.append(adapters[last_index : index + 1])
                last_index = index + 1
    permutations = 1
    for adapter_group in adapter_groups:
        open_set = [tuple(adapter_group)]
        closed_set = set()
        while open_set:
            adapter_group = open_set.pop()
            closed_set.add(tuple(adapter_group))
            for index in range(len(adapter_group)):
                if index < len(adapter_group) - 2 and adapter_group[index + 2] - adapter_group[index] <= 3:
                    next_group = tuple(adapter_group[: index + 1] + adapter_group[index + 2 :])
                    if next_group not in closed_set:
                        open_set.append(next_group)
                elif index < len(adapter_group) - 3 and adapter_group[index + 3] - adapter_group[index] <= 3:
                    next_group = tuple(adapter_group[: index + 1] + adapter_group[index + 3 :])
                    if next_group not in closed_set:
                        open_set.append(next_group)
        permutations *= len(closed_set)
    print(permutations)
    
if __name__ == '__main__':
    main()