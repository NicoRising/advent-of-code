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
            
            let matches = 0;

            for (const num of yours) {
                matches += winning.includes(num);
            }

            sum += Math.floor(2 ** (matches - 1));
        }

        console.log(sum);
    }
});
