def main():
    lines = open('input.txt', 'r').read().splitlines()
    count = 0
    group = ''
    for line in lines:
        if line:
            group += line
        else:
            count += len(set(group))
            group = ''
    print(count + len(set(group)))
    
if __name__ == '__main__':
    main()