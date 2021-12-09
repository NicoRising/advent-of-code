def main():
    lines = open('input.txt', 'r').read().splitlines()
    x = 0
    y = 0
    facing = 0
    for command in lines:
        if command[0] == 'N':
            y += int(command[1:])
        elif command[0] == 'S':
            y -= int(command[1:])
        elif command[0] == 'E':
            x += int(command[1:])
        elif command[0] == 'W':
            x -= int(command[1:])
        elif command[0] == 'L':
            facing = (facing + int(command[1:]) / 90) % 4
        elif command[0] == 'R':
            facing = (facing - int(command[1:]) / 90) % 4
        else:
            if facing == 0:
                x += int(command[1:])
            elif facing == 1:
                y += int(command[1:])
            elif facing == 2:
                x -= int(command[1:])
            else:
                y -= int(command[1:])
    print(abs(x) + abs(y))

if __name__ == '__main__':
    main()