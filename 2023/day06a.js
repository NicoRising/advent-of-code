const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        let [times, distances] = text.split("\n").map(line => line.match(/\d+/g));
        let totalWays = 1;

        for (let race = 0; race < times.length; race++) {
            const time = Number(times[race]);
            const distance = Number(distances[race]);

            let ways = 0;
 
            // I could use the quadratic equation but ¯\_(ツ)_/¯
            for (let holdTime = 0; holdTime < time; holdTime++) {
                if (holdTime * (time - holdTime) > distance) {
                    ways++;
                }
            }

            totalWays *= ways
        }

        console.log(totalWays);
    }
});
