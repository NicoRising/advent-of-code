def main():
    lines = open('input.txt', 'r').read().splitlines()
    for i in lines:
        for e in lines:
            if int(i) + int(e) == 2020:
                print(int(i) * int(e))
                quit()

if __name__ == '__main__':
    main()