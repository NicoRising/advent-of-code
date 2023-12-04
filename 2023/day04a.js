const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split("\n").slice(0, -1);

        let sum = 0;

        for (const line of lines) {
            let [yours, winning] = line.split("|");
            yours = yours.match(/\d+/g);
            yours = yours.slice(1);
            yours = [...new Set(yours)];
            winning = winning.match(/\d+/g);
            console.log(yours)
            console.log(winning)
            
            let score = 0;

            for (const num of yours) {
                if (winning.includes(num)) {
                    console.log(num);
                    if (score == 0) {
                        score++;
                    } else {
                        score *= 2;
                    }
                }
            }

            sum += score;
        }

        console.log(sum);
    }
});
