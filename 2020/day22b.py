def play(player1, player2):
    prev_rounds = set()
    while player1 and player2:
        if (tuple(player1), tuple(player2)) in prev_rounds:
            return (True, player1)
        prev_rounds.add((tuple(player1), tuple(player2)))
        a = player1.pop()
        b = player2.pop()
        if len(player1) >= a and len(player2) >= b:
            game = play(player1[-a :], player2[-b :])
            if game[0]:
                player1.insert(0, a)
                player1.insert(0, b)
            else:
                player2.insert(0, b)
                player2.insert(0, a)
        else:
            if a > b:
                player1.insert(0, a)
                player1.insert(0, b)
            else:
                player2.insert(0, b)
                player2.insert(0, a)
    if player1:
        return (True, player1)
    return (False, player2)

def main():
    lines = open('input.txt', 'r').read().splitlines()
    player1 = []
    player2 = []
    for line in lines[1:]:
        if not line:
            break
        player1.append(int(line))
    for line in lines[len(player1) + 3 :]:
        player2.append(int(line))
    player1 = player1[:: -1]
    player2 = player2[:: -1]
    winner = play(player1, player2)[1]
    score = 0
    for index in range(len(winner)):
        score += winner[index] * (index + 1)
    print(score)
    
if __name__ == '__main__':
    main()