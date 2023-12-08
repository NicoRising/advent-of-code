const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const [instructs, network] = text.split("\n\n");

        const map = new Map();
        let ghostLocs = [];

        for (const line of network.split("\n").slice(0, -1)) {
            const [node, left, right] = line.match(/[^=,() ]+/g);
            map.set(node, [left, right]);

            if (node.slice(-1) == "A") {
                ghostLocs.push(node);
            }
        }
        
        const foundCycles = Array(ghostLocs.length).fill(false);
        const factors = new Map();
        let lcm = 1;
        let step = 0;

        while (!foundCycles.every(i => i)) {
            const instruct = instructs[step % instructs.length];

            ghostLocs = ghostLocs.map((node, idx) => {
                if (node.slice(-1) == "Z") {
                    foundCycles[idx] = true;

                    let n = step;
                    let divisor = 2;

                    while (n > 1) {
                        let count = 0;

                        while (n % divisor == 0) {
                            n /= divisor;
                            count++;
                        }

                        if (count > 0 && (!factors.has(divisor) || factors.get(divisor) < count)) {
                            lcm *= Math.pow(divisor, count - (factors.get(divisor) || 0));
                            factors.set(divisor, count);
                        }

                        divisor++;
                    }
                }

                if (instruct == "L") {
                    return map.get(node)[0];
                } else {
                    return map.get(node)[1];
                }
            });

            step++;
        }

        console.log(lcm);
    }
});
