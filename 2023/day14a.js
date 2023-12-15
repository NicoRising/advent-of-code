const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const grid = text.split("\n").slice(0, -1).map(line => line.split(""));
        let load = 0;

        for (let row = 0; row < grid.length; row++) {
            for (let col = 0; col < grid[row].length; col++) {
                if (grid[row][col] == "O") {
                    let moveRow = row;

                    while (moveRow > 0 && grid[moveRow - 1][col] == ".") {
                        moveRow--;
                    }

                    grid[row][col] = ".";
                    grid[moveRow][col] = "O";

                    load += grid.length - moveRow;
                }
            }
        }

        console.log(load);
    }
});
