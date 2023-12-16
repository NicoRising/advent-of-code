const fs = require("node:fs");

function process(beam, grid) {
    let [row, col, dir] = beam;

    switch (dir) {
        case 0:
            col++;
            break;
        case 1:
            row++;
            break;
        case 2:
            col--;
            break;
        case 3:
            row--;
    }

    if (row >= 0 && row < grid.length && col >= 0 && col < grid[row].length) {
        let dirs;

        switch (grid[row][col]) {
            case "/":
                dirs = [[3, 2, 1, 0][dir]];
                break;
            case "\\":
                dirs = [[1, 0, 3, 2][dir]];
                break;
            case "-":
                dirs = [[0], [0, 2], [2], [0, 2]][dir];
                break;
            case "|":
                dirs = [[1, 3], [1], [1, 3], [3]][dir];
                break;
            default:
                dirs = [dir];
        }

        return [false, dirs.map(dir => [row, col, dir])];
    } else {
        return [true, [[row, col, dir]]];
    }
}

function calcEnergized(beam, grid) {
    const light = new Set();
    light.add(beam.join(","));

    const exitedTiles = new Set();
    let changed = true;

    while (changed) {
        changed = false;

        for (const beam of light) {
            const [exited, newBeams] = process(beam.split(",").map(val => Number(val)), grid);

            if (!exited) {
                for (const newBeam of newBeams) {
                    if (changed || !light.has(newBeam.join(","))) {
                        changed = true;
                    }

                    light.add(newBeam.join(","));
                }
            } else {
                exitedTiles.add(newBeams[0][0] + "," + newBeams[0][1]);
            }
        }
    }

    let energized = 0;

    for (let row = 0; row < grid.length; row++) {
        for (let col = 0; col < grid[row].length; col++) {
            for (let dir = 0; dir < 4; dir++) {
                if (light.has([row, col, dir].join(","))) {
                    energized++;
                    break;
                }
            }
        }
    }

    return [energized, exitedTiles];
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const grid = text.split("\n").slice(0, -1);

        const exitedTiles = new Set();
        let maxEnergized = 0;
        let nice = 0;

        for (let row = 0; row < grid.length; row++) {
            for (const [col, dir] of [[-1, 0], [grid[row].length, 2]]) {
                if (!exitedTiles.has(row + "," + col)) {
                    const [energized, newExited] = calcEnergized([row, col, dir], grid);
                    
                    maxEnergized = energized > maxEnergized ? energized : maxEnergized;
                    newExited.forEach(tile => exitedTiles.add(tile));
                }
            }
        }

        for (let col = 0; col < grid[0].length; col++) {
            for (const [row, dir] of [[-1, 1], [grid.length, 3]]) {
                if (!exitedTiles.has(row + "," + col)) {
                    const [energized, newExited] = calcEnergized([row, col, dir], grid);
                    
                    maxEnergized = energized > maxEnergized ? energized : maxEnergized;
                    newExited.forEach(tile => exitedTiles.add(tile));
                }
            }
        }
 
        console.log(maxEnergized);
    }
});
