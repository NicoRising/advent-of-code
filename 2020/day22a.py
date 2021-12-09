def main():
    lines = open('input.txt', 'r').read().splitlines()
    player1 = []
    player2 = []
    for line in lines[1 :]:
        if not line:
            break
        player1.append(int(line))
    for line in lines[len(player1) + 3 :]:
        player2.append(int(line))
    player1 = player1[:: -1]
    player2 = player2[:: -1]
    while player1 and player2:
        a = player1.pop()
        b = player2.pop()
        if a > b:
            player1.insert(0, a)
            player1.insert(0, b)
        else:
            player2.insert(0, b)
            player2.insert(0, a)
    if player1:
        winner = player1
    else:
        winner = player2
    score = 0
    for index in range(len(winner)):
        score += winner[index] * (index + 1)
    print(score)
    
if __name__ == '__main__':
    main()