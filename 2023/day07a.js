const fs = require("node:fs");

const rank = "AKQJT98765432";

function strength(hand) {
    const strength = [];
    const counts = new Map();

    for (const card of hand) {
        if (counts.has(card)) {
            counts.set(card, counts.get(card) + 1);    
        } else {
            counts.set(card, 1);
        }
    }

    const values = Array.from(counts.values());
    let type = 6;

    if (values.includes(5)) {
        type = 0;
    } else if (values.includes(4)) {
        type = 1;
    } else if (values.includes(3) && values.includes(2)) {
        type = 2;
    } else if (values.includes(3)) {
        type = 3;
    } else if (values.filter(count => count == 2).length == 2) {
        type = 4;
    } else if (values.includes(2)) {
        type = 5;
    }

    strength.push(type);

    for (const card of hand) {
        strength.push(rank.indexOf(card));
    }

    return strength
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split("\n").slice(0, -1).map(line => line.split(" "));
        lines.map(line => line.push(strength(line[0])));

        lines.sort((lineA, lineB) => {
            for (let idx = 0; idx < lineA[2].length; idx++) {
                const diff = lineB[2][idx] - lineA[2][idx];

                if (diff != 0) {
                    return diff;
                }
            }

            return 0;
        });

        let sum = 0;

        for (const [idx, line] of lines.entries()) {
            sum += (idx + 1) * Number(line[1])
        }

        console.log(sum);
    }
});
