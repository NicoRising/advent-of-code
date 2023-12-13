const fs = require("node:fs");

function sameRow(pattern, rowA, rowB, smudges) {
    for (let col = 0; col < pattern[0].length; col++) {
        if (pattern[rowA][col] != pattern[rowB][col]) {
            smudges++;

            if (smudges > 1) {
                return smudges;
            }
        }
    }

    return smudges;
}

function sameCol(pattern, colA, colB, smudges) {
    for (let row = 0; row < pattern.length; row++) {
        if (pattern[row][colA] != pattern[row][colB]) {
            smudges++;

            if (smudges > 1) {
                return smudges;
            }
        }
    }

    return smudges;
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
                let smudges = 0;

                while (row - gap >= 0 && row + gap + 1 < pattern.length) {
                    if ((smudges = sameRow(pattern, row - gap, row + gap + 1, smudges)) > 1) {
                        continue rowLoop;
                    }

                    gap++;
                }

                if (smudges == 1) {
                    rows += row + 1;
                    continue patternLoop;
                }
            }

            colLoop:
            for (let col = 0; col < pattern[0].length - 1; col++) {
                let gap = 0;
                let smudges = 0;

                while (col - gap >= 0 && col + gap + 1 < pattern[0].length) {
                    if ((smudges = sameCol(pattern, col - gap, col + gap + 1, smudges)) > 1) {
                        continue colLoop;
                    }

                    gap++;
                }

                if (smudges == 1) {
                    cols += col + 1;
                    break;
                }
            }

        }

        console.log(rows * 100 + cols)
    }
});
