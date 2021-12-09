def main():    
    lines = open('input.txt', 'r').read().splitlines()
    fliped = set()
    for tile in lines:
        tile = [int(i) for i in tile.replace('ne', '0').replace('se', '2').replace('sw', '3').replace('nw', '5').replace('e', '1').replace('w', '4')]
        last = None
        while tile != last:
            last = tile.copy()
            while 0 in tile and 2 in tile:
                tile.remove(0)
                tile.remove(2)
                tile.append(1)
            while 1 in tile and 3 in tile:
                tile.remove(1)
                tile.remove(3)
                tile.append(2)
            while 2 in tile and 4 in tile:
                tile.remove(2)
                tile.remove(4)
                tile.append(3)
            while 3 in tile and 5 in tile:
                tile.remove(3)
                tile.remove(5)
                tile.append(4)
            while 4 in tile and 0 in tile:
                tile.remove(4)
                tile.remove(0)
                tile.append(5)
            while 5 in tile and 1 in tile:
                tile.remove(5)
                tile.remove(1)
                tile.append(0)
        while 0 in tile and 3 in tile:
            tile.remove(0)
            tile.remove(3)
        while 1 in tile and 4 in tile:
            tile.remove(1)
            tile.remove(4)
        while 2 in tile and 5 in tile:
            tile.remove(2)
            tile.remove(5)
        tile.sort()
        tile = tuple(tile)
        if tile in fliped:
            fliped.remove(tile)
        else:
            fliped.add(tile)
    print(len(fliped))
    
if __name__ == '__main__':
    main()