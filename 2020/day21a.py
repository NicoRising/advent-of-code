def main():
    lines = open('input.txt', 'r').read().splitlines()
    food_list = []
    for line in lines:
        index = line.index('contains')
        food_list.append((line[index + 9 : -1].replace(',', '').split(' '), line[: index - 2].split(' ')))
    allergens = set()
    ingredients = set()
    for food in food_list:
        allergens.update(food[0])
        ingredients.update(food[1])
    language_dict = {}
    for ingredient in ingredients:
        if ingredient not in language_dict:
            for allergen in allergens:
                is_allergen = True
                for food in food_list:
                    if ingredient not in food[1] and allergen in food[0]:
                        is_allergen = False
                        break
                if is_allergen:
                    language_dict[ingredient] = allergen
    safe = ingredients - {*language_dict}
    count = 0
    for food in food_list:
        for ingredient in food[1]:
            count += ingredient in safe
    print(count)
    
if __name__ == '__main__':
    main()