def main():
    lines = open('input.txt', 'r').read().splitlines()
    id_list = []
    for board_pass in lines:
        board_pass = board_pass.replace('F', '0').replace('L', '0').replace('B', '1').replace('R', '1')
        id_list.append(int(board_pass[:7], 2) * 8 + int(board_pass[7:], 2))
    id_list.sort()
    for index in range(len(id_list) - 1):
        if id_list[index + 1] - id_list[index] == 2:
            print(id_list[index] + 1)
        
if __name__ == '__main__':
    main()