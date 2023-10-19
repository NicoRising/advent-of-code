import copy

STEPS = 6

def step(grid):
    copy_grid = copy.deepcopy(grid)
    for x in range(x_length):
        for y in range(y_length):
            for z in range(z_length):
                neighbor_count = get_neighbors((x, y, z), copy_grid)
                if copy_grid[x][y][z] == 0 and neighbor_count == 3:
                    grid[x][y][z] = 1
                elif copy_grid[x][y][z] == 1 and (neighbor_count < 2 or neighbor_count > 3):
                    grid[x][y][z] = 0
    return grid

def get_neighbors(coords, grid):
    count = 0
    for neighbor in neighbors[coords]:
        count += grid[neighbor[0]][neighbor[1]][neighbor[2]]
    return count

def setup(lines):
    global x_length
    global y_length
    global z_length
    global neighbors
    x_length = len(lines[0]) + STEPS * 2
    y_length = len(lines) + STEPS * 2
    z_length = STEPS * 2 + 1
    grid = []
    for x in range(x_length):
        grid.append([])
        for y in range(y_length):
            grid[x].append([])
            grid[x][y] = [0 for z in range(z_length)]
    for x in range(x_length - STEPS * 2):
        for y in range(y_length - STEPS * 2):
            if lines[y][x] == '#':
                grid[x + STEPS][y + STEPS][z_length // 2] = 1
    neighbors = {}
    for x in range(x_length): # TODO: Get neighbors better
        for y in range(y_length):
            for z in range(z_length):
                neighbor_list = []
                if x > 0:
                    neighbor_list.append((x - 1, y, z))
                    if y > 0:
                        neighbor_list.append((x - 1, y - 1, z))
                        if z > 0:
                            neighbor_list.append((x - 1, y - 1, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((x - 1, y - 1, z + 1))
                    if y < y_length - 1:
                        neighbor_list.append((x - 1, y + 1, z))
                        if z > 0:
                            neighbor_list.append((x - 1, y + 1, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((x - 1, y + 1, z + 1))
                    if z > 0:
                        neighbor_list.append((x - 1, y, z - 1))
                    if z < z_length - 1:
                        neighbor_list.append((x - 1, y, z + 1))
                if x < x_length - 1:
                    neighbor_list.append((x + 1, y, z))
                    if y > 0:
                        neighbor_list.append((x + 1, y - 1, z))
                        if z > 0:
                            neighbor_list.append((x + 1, y - 1, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((x + 1, y - 1, z + 1))
                    if y < y_length - 1:
                        neighbor_list.append((x + 1, y + 1, z))
                        if z > 0:
                            neighbor_list.append((x + 1, y + 1, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((x + 1, y + 1, z + 1))
                    if z > 0:
                        neighbor_list.append((x + 1, y, z - 1))
                    if z < z_length - 1:
                        neighbor_list.append((x + 1, y, z + 1))
                if y > 0:
                    neighbor_list.append((x, y - 1, z))
                    if z > 0:
                        neighbor_list.append((x, y - 1, z - 1))
                    if z < z_length - 1:
                        neighbor_list.append((x, y - 1, z + 1))
                if y < y_length - 1:
                    neighbor_list.append((x, y + 1, z))
                    if z > 0:
                        neighbor_list.append((x, y + 1, z - 1))
                    if z < z_length - 1:
                        neighbor_list.append((x, y + 1, z + 1))
                if z > 0:
                    neighbor_list.append((x, y, z - 1))
                if z < z_length - 1:
                    neighbor_list.append((x, y, z + 1))
                neighbors[(x, y, z)] = neighbor_list
    return grid

def main():
    lines = open('input.txt', 'r').read().splitlines()
    grid = setup(lines)
    for i in range(STEPS):
        grid = step(grid)
    count = 0
    for x in range(x_length):
        for y in range(y_length):
            for z in range(z_length):
                count += grid[x][y][z]
    print(count)
        
if __name__ == '__main__':
    main()