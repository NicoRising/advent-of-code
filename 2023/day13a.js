const fs = require("node:fs");

function sameRow(pattern, rowA, rowB) {
    for (let col = 0; col < pattern[0].length; col++) {
        if (pattern[rowA][col] != pattern[rowB][col]) {
            return false;
        }
    }

    return true;
}

function sameCol(pattern, colA, colB) {
    for (let row = 0; row < pattern.length; row++) {
        if (pattern[row][colA] != pattern[row][colB]) {
            return false;
        }
    }

    return true;
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const patterns = text.split("\n\n")
                             .map(pattern => pattern.split("\n").map(line => line.split("")));

        // Remove final new line
        patterns.at(-1).pop();

        let rows = 0;
        let cols = 0;

        patternLoop:
        for (const pattern of patterns) {
            rowLoop:
            for (let row = 0; row < pattern.length - 1; row++) {
                let gap = 0;

                while (row - gap >= 0 && row + gap + 1 < pattern.length) {
                    if (!sameRow(pattern, row - gap, row + gap + 1)) {
                        continue rowLoop;
                    }

                    gap++;
                }

                rows += row + 1;
                continue patternLoop;
            }

            colLoop:
            for (let col = 0; col < pattern[0].length - 1; col++) {
                let gap = 0;

                while (col - gap >= 0 && col + gap + 1 < pattern[0].length) {
                    if (!sameCol(pattern, col - gap, col + gap + 1)) {
                        continue colLoop;
                    }

                    gap++;
                }

                cols += col + 1;
            }

        }

        console.log(rows * 100 + cols)
    }
});
