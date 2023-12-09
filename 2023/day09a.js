const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const histories = text.split("\n").slice(0, -1)
                                          .map(line => line.split(" ")
                                          .map(num => Number(num)));

        let sum = 0;

        for (const history of histories) {
            const sequences = [history];
            let last = sequences.at(-1);

            while (last.some(num => num)) {
                sequences.push(last.slice(1).map((num, idx) => num - last[idx]));
                last = sequences.at(-1);
            }

            sum += sequences.reverse().reduce((acc, history) => acc + history.at(-1), 0);
        }
        
        console.log(sum);
    }
});
