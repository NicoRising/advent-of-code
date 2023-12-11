const fs = require("node:fs");

function distance(galaxy1, galaxy2) {
    return Math.abs(galaxy1[0] - galaxy2[0]) + Math.abs(galaxy1[1] - galaxy2[1]);
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split("\n").slice(0, -1).map(line => line.split(""));
        const height = lines.length;
        const width = lines[0].length;

        const emptyRows = new Set();
        const emptyCols = new Set();

        for (const [row, line] of lines.entries()) {
            if (line.indexOf("#") == -1) {
                emptyRows.add(row);
            }
        }

        for (let col = 0; col < width; col++) {
            if (lines.map(line => line[col]).every(chr => chr == ".")) {
                emptyCols.add(col);
            }
        }

        const galaxies = [];
        let rowOffset = 0;

        for (const [row, line] of lines.entries()) {
            let colOffset = 0;

            if (emptyRows.has(row)) {
                rowOffset++;
            } else {
                for (const [col, chr] of line.entries()) {
                    if (emptyCols.has(col)) {
                        colOffset++;
                    } else if (chr == "#") {
                        galaxies.push([row + rowOffset, col + colOffset]);
                    }
                }
            }
        }

        let dist = 0;

        for (const [idx, galaxy1] of galaxies.entries()) {
            for (const galaxy2 of galaxies.slice(idx)) {
                dist += distance(galaxy1, galaxy2);
            }
        }

        console.log(dist);
    }
});
