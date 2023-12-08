const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const [instructs, network] = text.split("\n\n");
        const map = new Map();

        for (const line of network.split("\n").slice(0, -1)) {
            const [node, left, right] = line.match(/[A-Z]+/g);
            map.set(node, [left, right]);
        }

        let currLoc = "AAA";
        let steps = 0;

        while (currLoc != "ZZZ") {
            const instruct = instructs[steps % instructs.length];

            if (instruct == "L") {
                currLoc = map.get(currLoc)[0];
            } else {
                currLoc = map.get(currLoc)[1];
            }

            steps++;
        }

        console.log(steps);
    }
});
