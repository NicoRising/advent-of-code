import copy

STEPS = 6

def step(grid):
    copy_grid = copy.deepcopy(grid)
    for w in range(w_length):
        for x in range(x_length):
            for y in range(y_length):
                for z in range(z_length):
                    neighbor_count = get_neighbors((w, x, y, z), copy_grid)
                    if copy_grid[w][x][y][z] == 0 and neighbor_count == 3:
                        grid[w][x][y][z] = 1
                    elif copy_grid[w][x][y][z] == 1 and (neighbor_count < 2 or neighbor_count > 3):
                        grid[w][x][y][z] = 0
    return grid

def get_neighbors(coords, grid):
    count = 0
    for neighbor in neighbors[coords]:
        count += grid[neighbor[0]][neighbor[1]][neighbor[2]][neighbor[3]]
    return count

def setup(lines):
    global w_length
    global x_length
    global y_length
    global z_length
    global neighbors
    w_length = STEPS * 2 + 1
    x_length = len(lines[0]) + STEPS * 2
    y_length = len(lines) + STEPS * 2
    z_length = STEPS * 2 + 1
    grid = []
    for w in range(w_length):
        grid.append([])
        for x in range(x_length):
            grid[w].append([])
            for y in range(y_length):
                grid[w][x].append([])
                grid[w][x][y] = [0 for z in range(z_length)]
    for x in range(x_length - STEPS * 2):
        for y in range(y_length - STEPS * 2):
            if lines[y][x] == '#':
                grid[w_length // 2][x + STEPS][y + STEPS][z_length // 2] = 1
    neighbors = {}
    for w in range(w_length): # TODO: Get neighbors much better
        for x in range(x_length):
            for y in range(y_length):
                for z in range(z_length):
                    neighbor_list = []
                    if w > 0:
                        neighbor_list.append((w - 1, x, y, z))
                        if x > 0:
                            neighbor_list.append((w - 1, x - 1, y, z))
                            if y > 0:
                                neighbor_list.append((w - 1, x - 1, y - 1, z))
                                if z > 0:
                                    neighbor_list.append((w - 1, x - 1, y - 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w - 1, x - 1, y - 1, z + 1))
                            if y < y_length - 1:
                                neighbor_list.append((w - 1, x - 1, y + 1, z))
                                if z > 0:
                                    neighbor_list.append((w - 1, x - 1, y + 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w - 1, x - 1, y + 1, z + 1))
                            if z > 0:
                                neighbor_list.append((w - 1, x - 1, y, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w - 1, x - 1, y, z + 1))
                        if x < x_length - 1:
                            neighbor_list.append((w - 1, x + 1, y, z))
                            if y > 0:
                                neighbor_list.append((w - 1, x + 1, y - 1, z))
                                if z > 0:
                                    neighbor_list.append((w - 1, x + 1, y - 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w - 1, x + 1, y - 1, z + 1))
                            if y < y_length - 1:
                                neighbor_list.append((w - 1, x + 1, y + 1, z))
                                if z > 0:
                                    neighbor_list.append((w - 1, x + 1, y + 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w - 1, x + 1, y + 1, z + 1))
                            if z > 0:
                                neighbor_list.append((w - 1, x + 1, y, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w - 1, x + 1, y, z + 1))
                        if y > 0:
                            neighbor_list.append((w - 1, x, y - 1, z))
                            if z > 0:
                                neighbor_list.append((w - 1, x, y - 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w - 1, x, y - 1, z + 1))
                        if y < y_length - 1:
                            neighbor_list.append((w - 1, x, y + 1, z))
                            if z > 0:
                                neighbor_list.append((w - 1, x, y + 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w - 1, x, y + 1, z + 1))
                        if z > 0:
                            neighbor_list.append((w - 1, x, y, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((w - 1, x, y, z + 1))
                    if w < w_length - 1:
                        neighbor_list.append((w + 1, x, y, z))
                        if x > 0:
                            neighbor_list.append((w + 1, x - 1, y, z))
                            if y > 0:
                                neighbor_list.append((w + 1, x - 1, y - 1, z))
                                if z > 0:
                                    neighbor_list.append((w + 1, x - 1, y - 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w + 1, x - 1, y - 1, z + 1))
                            if y < y_length - 1:
                                neighbor_list.append((w + 1, x - 1, y + 1, z))
                                if z > 0:
                                    neighbor_list.append((w + 1, x - 1, y + 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w + 1, x - 1, y + 1, z + 1))
                            if z > 0:
                                neighbor_list.append((w + 1, x - 1, y, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w + 1, x - 1, y, z + 1))
                        if x < x_length - 1:
                            neighbor_list.append((w + 1, x + 1, y, z))
                            if y > 0:
                                neighbor_list.append((w + 1, x + 1, y - 1, z))
                                if z > 0:
                                    neighbor_list.append((w + 1, x + 1, y - 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w + 1, x + 1, y - 1, z + 1))
                            if y < y_length - 1:
                                neighbor_list.append((w + 1, x + 1, y + 1, z))
                                if z > 0:
                                    neighbor_list.append((w + 1, x + 1, y + 1, z - 1))
                                if z < z_length - 1:
                                    neighbor_list.append((w + 1, x + 1, y + 1, z + 1))
                            if z > 0:
                                neighbor_list.append((w + 1, x + 1, y, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w + 1, x + 1, y, z + 1))
                        if y > 0:
                            neighbor_list.append((w + 1, x, y - 1, z))
                            if z > 0:
                                neighbor_list.append((w + 1, x, y - 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w + 1, x, y - 1, z + 1))
                        if y < y_length - 1:
                            neighbor_list.append((w + 1, x, y + 1, z))
                            if z > 0:
                                neighbor_list.append((w + 1, x, y + 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w + 1, x, y + 1, z + 1))
                        if z > 0:
                            neighbor_list.append((w + 1, x, y, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((w + 1, x, y, z + 1))
                    if x > 0:
                        neighbor_list.append((w, x - 1, y, z))
                        if y > 0:
                            neighbor_list.append((w, x - 1, y - 1, z))
                            if z > 0:
                                neighbor_list.append((w, x - 1, y - 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w, x - 1, y - 1, z + 1))
                        if y < y_length - 1:
                            neighbor_list.append((w, x - 1, y + 1, z))
                            if z > 0:
                                neighbor_list.append((w, x - 1, y + 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w, x - 1, y + 1, z + 1))
                        if z > 0:
                            neighbor_list.append((w, x - 1, y, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((w, x - 1, y, z + 1))
                    if x < x_length - 1:
                        neighbor_list.append((w, x + 1, y, z))
                        if y > 0:
                            neighbor_list.append((w, x + 1, y - 1, z))
                            if z > 0:
                                neighbor_list.append((w, x + 1, y - 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w, x + 1, y - 1, z + 1))
                        if y < y_length - 1:
                            neighbor_list.append((w, x + 1, y + 1, z))
                            if z > 0:
                                neighbor_list.append((w, x + 1, y + 1, z - 1))
                            if z < z_length - 1:
                                neighbor_list.append((w, x + 1, y + 1, z + 1))
                        if z > 0:
                            neighbor_list.append((w, x + 1, y, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((w, x + 1, y, z + 1))
                    if y > 0:
                        neighbor_list.append((w, x, y - 1, z))
                        if z > 0:
                            neighbor_list.append((w, x, y - 1, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((w, x, y - 1, z + 1))
                    if y < y_length - 1:
                        neighbor_list.append((w, x, y + 1, z))
                        if z > 0:
                            neighbor_list.append((w, x, y + 1, z - 1))
                        if z < z_length - 1:
                            neighbor_list.append((w, x, y + 1, z + 1))
                    if z > 0:
                        neighbor_list.append((w, x, y, z - 1))
                    if z < z_length - 1:
                        neighbor_list.append((w, x, y, z + 1))
                    neighbors[(w, x, y, z)] = neighbor_list
    return grid

def main():
    lines = open('input.txt', 'r').read().splitlines()
    grid = setup(lines)
    for i in range(STEPS):
        grid = step(grid)
    count = 0
    for w in range(w_length):
        for x in range(x_length):
            for y in range(y_length):
                for z in range(z_length):
                    count += grid[w][x][y][z]
    print(count)
        
if __name__ == '__main__':
    main()