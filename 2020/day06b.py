def main():
    lines = open('input.txt', 'r').read().splitlines()
    lines.append('')
    count = 0
    group = ''
    group_size = 0
    for line in lines:
        if group_size == 0:
            first_person = line
        if line:
            group += line
            group_size += 1
        else:
            for char in first_person:
                if group.count(char) == group_size:
                    count += 1
            group = ''
            group_size = 0
    print(count)

if __name__ == '__main__':
    main()