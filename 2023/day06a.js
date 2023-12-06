const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        let [times, distances] = text.split("\n").map(line => line.match(/\d+/g));
        times = times.map(Number);
        distances = distances.map(Number);

        let totalWays = 1;

        for (let race = 0; race < times.length; race++) {
            const time = times[race];
            const distance = distances[race];
            let ways = 0;

            for (let holdTime = 0; holdTime < time; holdTime++) {
                if (holdTime * (time - holdTime) > distance) {
                    ways++;
                    console.log(holdTime);
                }
            }

            totalWays *= ways
            console.log(ways);
            console.log()
        }

        console.log(totalWays);
    }
});
