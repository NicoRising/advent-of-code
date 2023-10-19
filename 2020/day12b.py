def main():
    lines = open('input.txt', 'r').read().splitlines()
    x = 0
    y = 0
    target_x = 10
    target_y = 1
    for command in lines:
        if command[0] == 'N':
            target_y += int(command[1:])
        elif command[0] == 'S':
            target_y -= int(command[1:])
        elif command[0] == 'E':
            target_x += int(command[1:])
        elif command[0] == 'W':
            target_x -= int(command[1:])
        elif command[0] == 'L':
            for i in range(int(command[1:]) // 90):
                original_x = target_x
                target_x = -target_y
                target_y = original_x
        elif command[0] == 'R':
            for i in range(int(command[1:]) // 90):
                original_x = target_x
                target_x = target_y
                target_y = -original_x
        else:
            x += int(command[1:]) * target_x
            y += int(command[1:]) * target_y
    print(abs(x) + abs(y))
        
if __name__ == '__main__':
    main()