def main():
    lines = open('input.txt', 'r').read().splitlines()
    numbers = {int(number[1]): int(number[0]) for number in enumerate(lines[0].split(','))}
    turn = 0
    t = len(numbers) + 1
    while t < 30000000: # TODO: Smarter method that doesn't involve waiting 10 seconds
        if turn in numbers:
            prev_turn = turn
            turn = t - numbers[turn] - 1
            numbers[prev_turn] = t - 1
        else:
            numbers[turn] = t - 1
            turn = 0
        t += 1
    print(turn)
        
if __name__ == '__main__':
    main()