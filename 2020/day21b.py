import copy
import random

def main():
    lines = open('input.txt', 'r').read().splitlines()
    food_list = []
    for line in lines:
        index = line.index('contains')
        food_list.append([line[index + 9 : -1].replace(',', '').split(' '), line[: index - 2].split(' ')])
    allergens = set()
    ingredients = set()
    for food in food_list:
        allergens.update(food[0])
        ingredients.update(food[1])
    dangerous = set()
    for ingredient in ingredients:
        if ingredient not in dangerous:
            for allergen in allergens:
                is_dangerous = True
                for food in food_list:
                    if ingredient not in food[1] and allergen in food[0]:
                        is_dangerous = False
                        break
                if is_dangerous:
                    dangerous.add(ingredient)
    for food in food_list:
        remove = set()
        for ingredient in food[1]:
            if ingredient not in dangerous:
                remove.add(ingredient)
        for ingredient in remove:
            food[1].remove(ingredient)
    disproved_dict = {}
    for ingredient in dangerous:
        if ingredient not in disproved_dict:
            disproved_dict[ingredient] = set()
        for allergen in allergens:
            disproved = True
            for food in food_list:
                if ingredient in food[1] and allergen in food[0]:
                    disproved = False
                if not disproved and ingredient not in food[1] and allergen in food[0]:
                    disproved = True
                    break
            if disproved:
                disproved_dict[ingredient].add(allergen)
    dangerous_list = list(dangerous)
    bad_combos = []
    conclusive = False
    while not conclusive:
        language_dict = {}
        test_disproved = copy.deepcopy(disproved_dict)
        assignments = list(allergens)
        while assignments in bad_combos:
            random.shuffle(assignments)
        bad_combos.append(assignments)
        conclusive = True
        for index in range(len(dangerous)):
            if assignments[index] in disproved_dict[dangerous_list[index]]:
                conclusive = False
                break
            language_dict[dangerous_list[index]] = assignments[index]
        if conclusive:
            for food in copy.deepcopy(food_list):
                food[1] = [language_dict[ingredient] for ingredient in food[1]]
                for allergen in food[0]:
                    if allergen not in food[1]:
                        conclusive = False
                        break
    alphabetical = list(allergens)
    alphabetical.sort()
    for ingredient in language_dict:
        alphabetical[alphabetical.index(language_dict[ingredient])] = ingredient
    alphabetical = ','.join(alphabetical)
    print(alphabetical)
    
if __name__ == '__main__':
    main()