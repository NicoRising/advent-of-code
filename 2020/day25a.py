def encrypt(value, subject, loop):
    for i in range(loop):
        value *= subject
        value %= 20201227
    return value

def main():
    lines = open('input.txt', 'r').read().splitlines()
    door = int(lines[0])
    key = int(lines[1])
    loop = 0
    value = 1
    found = False
    while not found:
        loop += 1
        value = encrypt(value, 7, 1)
        found = value == door
    print(encrypt(1, key, loop))

if __name__ == '__main__':
    main()