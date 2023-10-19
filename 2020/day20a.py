def main():
    lines = open('input.txt','r').read().splitlines()
    tiles = {}
    for line in lines:
        if ':' in line:
            tiles[line[-5 : -1]] = []
            current = line[-5 : -1]
        elif line:
            tiles[current].append([int(char == '#') for char in line])
    edges = {}
    for tile in tiles:
        edges[tile] = []
        edges[tile].append(tiles[tile][0])
        edges[tile].append(edges[tile][-1][:: -1])
        edges[tile].append(tiles[tile][-1])
        edges[tile].append(edges[tile][-1][:: -1])
        edges[tile].append([tiles[tile][row][0] for row in range(len(tiles[tile]))])
        edges[tile].append(edges[tile][-1][:: -1])
        edges[tile].append([tiles[tile][row][-1] for row in range(len(tiles[tile]))])
        edges[tile].append(edges[tile][-1][:: -1])
    neighbors = {}
    for tile in tiles:
        neighbors[tile] = set()
        for edge_index in range(8):
            for test in tiles:
                if tile != test:
                    for test_edge_index in range(8):
                        if edges[tile][edge_index] == edges[test][test_edge_index]:
                            neighbors[tile].add(test)
    total = 1
    for tile in neighbors:
        if len(neighbors[tile]) == 2:
            total *= int(tile)
    print(total)
        
if __name__ == '__main__':
    main()