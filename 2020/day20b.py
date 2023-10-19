import copy

def build_tile_grid(tile_neighbors):
    corners = set()
    edges = set()
    middles = set()
    for tile in tile_neighbors:
        if len(tile_neighbors[tile]) == 2:
            corners.add(tile)
        elif len(tile_neighbors[tile]) == 3:
            edges.add(tile)
        else:
            middles.add(tile)
    tile_grid = [[0 for i in range(GRID_WIDTH)] for e in range(GRID_WIDTH)]
    tile_grid[0][0] = corners.pop()
    for x in range(1, GRID_WIDTH - 1):
        for tile in edges:
            if tile_grid[x - 1][0] in tile_neighbors[tile]:
                tile_grid[x][0] = tile
                edges.discard(tile)
                break
    for y in range(1, GRID_WIDTH - 1):
        for tile in edges:
            if tile_grid[0][y - 1] in tile_neighbors[tile]:
                tile_grid[0][y] = tile
                edges.discard(tile)
                break
    for tile in corners:
        if tile_grid[0][ - 2] in tile_neighbors[tile]:
            tile_grid[0][ - 1] = tile
            corners.discard(tile)
            break
    for tile in corners:
        if tile_grid[ - 2][0] in tile_neighbors[tile]:
            tile_grid[ - 1][0] = tile
            corners.discard(tile)
            break
    for x in range(1, GRID_WIDTH - 1):
        for tile in edges:
            if tile_grid[x - 1][ - 1] in tile_neighbors[tile]:
                tile_grid[x][ - 1] = tile
                edges.discard(tile)
                break
    for y in range(1, GRID_WIDTH - 1):
        for tile in edges:
            if tile_grid[ - 1][y - 1] in tile_neighbors[tile]:
                tile_grid[ - 1][y] = tile
                edges.discard(tile)
                break
    tile_grid[ - 1][ - 1] = corners.pop()
    for x in range(1, GRID_WIDTH - 1):
        for y in range(1, GRID_WIDTH - 1):
            for tile in middles:
                if tile_grid[x - 1][y] in tile_neighbors[tile] and tile_grid[x][y - 1] in tile_neighbors[tile]:
                    tile_grid[x][y] = tile
                    middles.discard(tile)
                    break
    return tile_grid

def get_group(tile):
    group = []
    group.append(tile)
    group.append(flip(group[-1]))
    group.append(rotate(group[-2]))
    group.append(flip(group[-1]))
    group.append(rotate(group[-2]))
    group.append(flip(group[-1]))
    group.append(rotate(group[-2]))
    group.append(flip(group[-1]))
    return group
      
def rotate(tile):
   width = len(tile)
   rotated = copy.deepcopy(tile)
   for level in range(width // 2):
      for pos in range(level, width - level):
         rotated[pos][level] = tile[level][-pos - 1]
         rotated[level][-pos - 1] = tile[ - pos - 1][-level - 1]
         rotated[-pos - 1][-level - 1] = tile[-level - 1][pos]
         rotated[-level - 1][pos] = tile[pos][level]
   return rotated

def flip(tile):
   flipped = []
   for row in tile:
      flipped.append(row[:: -1])
   return flipped

def get_edges(tile):
   edges = []
   edges.append(tile[0])
   edges.append(tile[ - 1])
   edges.append([tile[row][0] for row in range(TILE_WIDTH)])
   edges.append([tile[row][ - 1] for row in range(TILE_WIDTH)])
   return edges

def setup(lines):
    global TILE_WIDTH
    global GRID_WIDTH
    tiles = {}
    for line in lines:
        if ':' in line:
            tiles[line[-5 : -1]] = []
            current = line[-5 : -1]
        elif line:
            tiles[current].append([int(char == '#') for char in line])
            TILE_WIDTH = len(line)
    GRID_WIDTH = int(len(tiles) ** .5)
    return tiles

def display_fancy(tile):
    for row in range(len(tile)):
        if row != 0 and row % 10 == 0:
            print(' - ' * (TILE_WIDTH * GRID_WIDTH + GRID_WIDTH - 1))
        next_print = ''
        for type in tile[row]:
            if len(next_print) != 0 and (len(next_print) - next_print.count('|')) % 10 == 0:
                next_print += '|'
            if type == 0:
                next_print += '.'
            else:
                next_print += '#'
        print(next_print)
      
def display(tile):
    for row in range(len(tile)):
        next_print = ''
        for type in tile[row]:
            if type == 0:
                next_print += '.'
            else:
                next_print += '#'
        print(next_print)

def main():
    lines = open('input.txt', 'r').read().splitlines() # FIXME: Everything
    tiles = setup(lines)
    for tile in tiles:
        tiles[tile] = get_group(tiles[tile])
    tile_neighbors = {}
    for tile_a in tiles:
        tile_neighbors[tile_a] = set()
        for tile_b in tiles:
            if tile_a != tile_b:
                for group_a in tiles[tile_a]:
                    for group_b in tiles[tile_b]:
                        for edge in get_edges(group_a):
                            if edge in get_edges(group_b):
                                tile_neighbors[tile_a].add(tile_b)
    tile_grid = build_tile_grid(tile_neighbors)
    for start in range(8):
        queue = tile_neighbors[tile_grid[1][1]].copy()
        visited = {tile_grid[1][1]}
        grid = [[0 for col in range(GRID_WIDTH)] for row in range(GRID_WIDTH)]
        grid[1][1] = tiles[tile_grid[1][1]][start]
        while queue:
            current = queue.pop()
            if current not in visited:
                visited.add(current)
                queue = queue | tile_neighbors[current]
                for row in range(GRID_WIDTH):
                    for col in range(GRID_WIDTH):
                        if tile_grid[row][col] == current:
                            location = (row, col)
                            break
                if location[0] > 0 and grid[location[0] - 1][location[1]] != 0:
                    parent = get_edges(grid[location[0] - 1][location[1]])[1]
                    edge = 0
                elif location[0] < GRID_WIDTH - 1 and grid[location[0] + 1][location[1]] != 0:
                    parent = get_edges(grid[location[0] + 1][location[1]])[0]
                    edge = 1
                elif location[1] > 0 and grid[location[0]][location[1] - 1] != 0:
                    parent = get_edges(grid[location[0]][location[1] - 1])[3]
                    edge = 2
                elif location[1] < GRID_WIDTH - 1 and grid[location[0]][location[1] + 1] != 0:
                    parent = get_edges(grid[location[0]][location[1] + 1])[2]
                    edge = 3
                for group in tiles[current]:
                    if parent == get_edges(group)[edge]:
                        grid[location[0]][location[1]] = group
                        break
        complete = True
        for row in grid:
            if 0 in row:
                complete = False
        if complete:
            break
    combined = []
    count = 0
    for row in range(GRID_WIDTH):
        for tile_row in range(1, TILE_WIDTH - 1):
            combined_row = []
            for col in range(GRID_WIDTH):
                combined_row += grid[row][col][tile_row][1: - 1]
            count += combined_row.count(1)
            combined.append(combined_row)
    sea_monster = '                  # \n#    ##    ##    ###\n #  #  #  #  #  #   '
    monster_size = sea_monster.count('#')
    sea_monster = [[int(char == '#') for char in line] for line in sea_monster.split('\n')]
    for image in get_group(combined):
        sea_monsters = 0
        for row in range((TILE_WIDTH - 2) * GRID_WIDTH - len(sea_monster)):
            for col in range((TILE_WIDTH - 2) * GRID_WIDTH - len(sea_monster[0])):
                test_monster = [image[row + height][col : col + len(sea_monster[0])] for height in range(len(sea_monster))]
                is_monster = True
                for level in range(len(sea_monster)):
                    for index in range(len(sea_monster[level])):
                        if sea_monster[level][index] == 1 and test_monster[level][index] == 0:
                            is_monster = False
                            break
                sea_monsters += is_monster
        if sea_monsters:
            print(count - sea_monsters * monster_size)
            break
                
if __name__ == '__main__':
    main()