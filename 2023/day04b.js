const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split("\n").slice(0, -1);
        const cardMap = new Map()
        const wins = []

        for (const line of lines) {
            let [yours, winning] = line.split("|");
            yours = yours.match(/\d+/g);
            yours = yours.slice(1);
            yours = [...new Set(yours)];
            winning = winning.match(/\d+/g);
            
            let score = 0;

            for (const num of yours) {
                if (winning.includes(num)) {
                    score++;
                }
            }

            wins.push(score)
        }

        cards = Array(lines.length).fill(1)
        
        for (let card = 0; card < wins.length; card++) {
            for (let next = card + 1; next <= card + wins[card]; next++) {
                cards[next] += cards[card];
            }
        }

        const sum = cards.reduce((partialSum, a) => partialSum + a, 0);
        console.log(sum)
    }
});
