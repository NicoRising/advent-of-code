const fs = require("node:fs");

function slide(grid, dir) {
    let startRow = 0;
    let startCol = 0;

    let endRow = grid.length;
    let endCol = grid[0].length;

    if (dir == 2) {
        startRow = endRow - 1;
        endRow = -1;
    } else if (dir == 3) {
        startCol = endCol - 1;
        endCol = -1;
    }

    for (let row = startRow; row != endRow; row < endRow ? row++ : row--) {
        for (let col = startCol; col != endCol; col < endCol ? col++ : col--) {
            if (grid[row][col] == "O") {
                let moveRow = row;
                let moveCol = col;

                switch (dir) {
                    case 0:
                        while (moveRow > 0 && grid[moveRow - 1][col] == ".") {
                            moveRow--;
                        }
                        break;
                    case 1:
                        while (moveCol > 0 && grid[row][moveCol - 1] == ".") {
                            moveCol--;
                        }
                        break;
                    case 2:
                        while (moveRow < grid.length - 1 && grid[moveRow + 1][col] == ".") {
                            moveRow++;
                        }
                        break;
                    case 3:
                        while (moveCol < grid[row].length - 1 && grid[row][moveCol + 1] == ".") {
                            moveCol++;
                        }
                }

                grid[row][col] = ".";
                grid[moveRow][moveCol] = "O";
            }
        }
    }
}

function calcLoad(grid) {
    let load = 0;

    for (let row = 0; row < grid.length; row++) {
        for (let col = 0; col < grid[row].length; col++) {
            if (grid[row][col] == "O") {
                load += grid.length - row;
            }
        }
    }

    return load;
}

// Could probably do something better to check history
function stringify(grid) {
    return grid.map(row => row.join("")).join("\n");
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const grid = text.split("\n").slice(0, -1).map(line => line.split(""));
        const visited = new Map();
        let cycle = 0;

        for (; !visited.has(stringify(grid)); cycle++) {
            visited.set(stringify(grid), cycle);

            for (let dir = 0; dir < 4; dir++) {
                slide(grid, dir);
            }
        }

        const cycleLength = cycle - visited.get(stringify(grid));

        for (let remainder = 0; remainder < (1_000_000_000 - cycle) % cycleLength; remainder++) {
            for (let dir = 0; dir < 4; dir++) {
                slide(grid, dir);
            }
        }

        console.log(calcLoad(grid));
    }
});
