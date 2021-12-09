def main():
    lines = open('input.txt','r').read().splitlines()
    correct = 0
    for line in lines:
        min_count = int(line[:line.index('-')])
        max_count = int(line[line.index('-') + 1 : line.index(' ')])
        target = line[line.index(' ') + 1]
        if min_count <= line[line.index(':') + 2 :].count(target) <= max_count:
            correct += 1
    print(correct)
    
if __name__ == '__main__':
    main()