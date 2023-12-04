const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split("\n").slice(0, -1);
        let sum = 0;

        for (const line of lines) {
            let [yours, winning] = line.substring(line.indexOf(":")).split("|");
            yours = yours.match(/\d+/g);
            winning = winning.match(/\d+/g);
            
            const unique = new Set([...yours, ...winning]).size;
            const matches = yours.length + winning.length - unique;
            sum += Math.floor(2 ** (matches - 1));
        }

        console.log(sum);
    }
});
