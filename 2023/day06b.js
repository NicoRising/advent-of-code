const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        let [times, distances] = text.split("\n").map(line => line.match(/\d+/g));
        const time = Number(times.reduce((acc, a) => acc + a, ""));
        const distance = Number(distances.reduce((acc, a) => acc + a, ""));

        console.log(time);
        console.log(distance);

        let ways = 0;

        for (let holdTime = 0; holdTime < time; holdTime++) {
            if (holdTime * (time - holdTime) > distance) {
                ways++;
            }
        }

        console.log(ways);
    }
});
