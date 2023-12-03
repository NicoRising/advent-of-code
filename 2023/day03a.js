const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split("\n").slice(0, -1);
        const height = lines.length;
        const width = lines[0].length;

        let sum = 0;

        for (const [row, line] of lines.entries()) {
            let lastMatch = 0;
            let match;

            matchLoop:
            while (match = /\d+/.exec(line.substring(lastMatch))) {
                const num = match[0];
                lastMatch += match.index + num.length;

                const startRow = Math.max(row - 1, 0);
                const stopRow = Math.min(row + 1, height - 1);
                const startCol = Math.max(lastMatch - num.length - 1, 0);
                const stopCol = Math.min(lastMatch, width - 1);

                for (let adjRow = startRow; adjRow <= stopRow; adjRow++) {
                    for (let adjCol = startCol; adjCol <= stopCol; adjCol++) {
                        if (/[^\d\.]/.test(lines[adjRow][adjCol])) {
                            sum += Number(num);
                            continue matchLoop;
                        }
                    }
                }
            }
        }

        console.log(sum);
    }
});
