import copy

def step(grid):
    next_grid = copy.deepcopy(grid)
    for row in range(HEIGHT):
        for col in range(WIDTH):
            if grid[row][col] == 1 and get_neighbors(grid, row, col) == 0:
                next_grid[row][col] = 2
            elif grid[row][col] == 2 and get_neighbors(grid, row, col) >= 4:
                next_grid[row][col] = 1
    return next_grid

def get_neighbors(grid, row, col):
    adjacent = 0
    for neighbor in NEIGHBORS[(row, col)]:
        if grid[neighbor[0]][neighbor[1]] == 2:
            adjacent += 1
    return adjacent

def setup(lines):
    global WIDTH
    global HEIGHT
    global NEIGHBORS
    WIDTH = len(lines[0])
    HEIGHT = len(lines)
    NEIGHBORS = {}
    for row in range(HEIGHT):
        for col in range(WIDTH):
            neighbor_set = set()
            if row > 0:
                neighbor_set.add((row - 1, col))
                if col > 0:
                    neighbor_set.add((row - 1, col - 1))
                if col < WIDTH - 1:
                    neighbor_set.add((row - 1, col + 1))
            if row < HEIGHT - 1:
                neighbor_set.add((row + 1, col))
                if col > 0:
                    neighbor_set.add((row + 1, col - 1))
                if col < WIDTH - 1:
                    neighbor_set.add((row + 1, col + 1))
            if col > 0:
                neighbor_set.add((row, col - 1))
            if col < WIDTH - 1:
                neighbor_set.add((row, col + 1))
            NEIGHBORS[(row, col)] = neighbor_set
    grid = []
    for row in range(HEIGHT):
        grid.append([])
        for col in range(WIDTH):
            if lines[row][col] == '.':
                grid[row].append(0)
            else:
                grid[row].append(1)
    return grid

def display(grid):
    for line in grid:
        next_print = ''
        for type in line:
            if type == 0:
                next_print += '.'
            elif type == 1:
                next_print += 'L'
            else:
                next_print += '#'
        print(next_print)

def main():
    lines = open('input.txt', 'r').read().splitlines()
    grid = setup(lines)
    is_stable = False
    while not is_stable:
        old_grid = grid
        grid = step(grid)
        if grid == old_grid:
            is_stable = True
    count = 0
    for col in range(WIDTH):
        for row in range(HEIGHT):
            count += grid[row][col] == 2
    print(count)
        
if __name__ == '__main__':
    main()