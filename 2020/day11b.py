import copy

def step(grid):
    next_grid = copy.deepcopy(grid)
    for row in range(HEIGHT):
        for col in range(WIDTH):
            if grid[row][col] == 1 and get_neighbors(grid, row, col) == 0:
                next_grid[row][col] = 2
            elif grid[row][col] == 2 and get_neighbors(grid, row, col) >= 5:
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
    grid = []
    for row in range(HEIGHT):
        grid.append([])
        for col in range(WIDTH):
            if lines[row][col] == '.':
                grid[row].append(0)
            else:
                grid[row].append(1)
    NEIGHBORS = {}
    for row in range(HEIGHT):
        for col in range(WIDTH):
            neighborSet = set()
            test_row = row
            test_col = col
            while test_row > 0:
                test_row -= 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            test_row = row
            test_col = col
            while test_col < WIDTH - 1:
                test_col += 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            test_row = row
            test_col = col
            while test_row < HEIGHT - 1:
                test_row += 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            test_row = row
            test_col = col
            while test_col > 0:
                test_col -= 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            test_row = row
            test_col = col
            while test_row > 0 and test_col < WIDTH - 1:
                test_row -= 1
                test_col += 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            test_row = row
            test_col = col
            while test_row < HEIGHT - 1 and test_col < WIDTH - 1:
                test_row += 1
                test_col += 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            test_row = row
            test_col = col
            while test_row < HEIGHT - 1 and test_col > 0:
                test_row += 1
                test_col -= 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            test_row = row
            test_col = col
            while test_row > 0 and test_col > 0:
                test_row -= 1
                test_col -= 1
                if grid[test_row][test_col] != 0:
                    neighborSet.add((test_row, test_col))
                    break
            NEIGHBORS[(row, col)] = neighborSet
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