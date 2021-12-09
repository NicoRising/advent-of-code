def main():
    lines = open('input.txt', 'r').read().splitlines()
    for i in lines:
        for e in lines:
            for j in lines:
                if int(i) + int(e) + int(j) == 2020:
                    print(int(i) * int(e) * int(j))
                    quit()
                
if __name__ == '__main__':
    main()