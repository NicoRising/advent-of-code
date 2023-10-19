def main():
    lines = open('input.txt', 'r').read().splitlines()
    max_id = 0
    for board_pass in lines:
        board_pass = board_pass.replace('F', '0').replace('L', '0').replace('B', '1').replace('R', '1')
        seat_id = int(board_pass[:7], 2) * 8 + int(board_pass[7:], 2)
        if seat_id > max_id:
            max_id = seat_id
    print(max_id)

if __name__ == '__main__':
    main()