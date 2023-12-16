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

        return dirs.map(dir => [row, col, dir]);
    } else {
        return [];
    }
}

function calcEnergized(beam, grid) {
    const light = new Set();
    light.add(beam.join(","));

    let changed = true;

    while (changed) {
        changed = false;
        for (let beam of light) {
            beam = beam.split(",").map(val => Number(val));

            for (const newBeam of process(beam, grid)) {
                if (changed || !light.has(newBeam.join(","))) {
                    changed = true;
                }

                light.add(newBeam.join(","));
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

    return energized;
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const grid = text.split("\n").slice(0, -1);

        let maxEnergized = 0;

        for (let row = 0; row < grid.length; row++) {
            maxEnergized = Math.max(calcEnergized([row, -1, 0], grid), maxEnergized);
            maxEnergized = Math.max(calcEnergized([row, grid[row].length, 2], grid), maxEnergized);
        }

        for (let col = 0; col < grid[0].length; col++) {
            maxEnergized = Math.max(calcEnergized([-1, col, 1], grid), maxEnergized);
            maxEnergized = Math.max(calcEnergized([grid.length, col, 3], grid), maxEnergized);
        }
 
        console.log(maxEnergized);
    }
});
