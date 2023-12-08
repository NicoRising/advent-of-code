const fs = require("node:fs");

const rank = "AKQT98765432J";

function combinations(counts) {
    let combs = [counts];

    if (counts.has("J")) {
        const jokerCount = counts.get("J");

        if (jokerCount > 0) {
            counts.set("J", jokerCount - 1);

            for (const card of counts.keys()) {
                if (card != "J") {
                    const count = counts.get(card);

                    counts.set(card, count + 1);
                    combs = combs.concat(combinations(new Map(counts)));
                    counts.set(card, count);
                }
            }

            counts.set("J", jokerCount);
        }
    }
    
    return combs;
}

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

    let bestType = 6;

    for (const comb of combinations(counts)) {
        const values = Array.from(comb.values());
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

        if (type < bestType) {
            bestType = type;
        }
    }
    
    strength.push(bestType);

    for (const card of hand) {
        strength.push(rank.indexOf(card));
    }

    return strength;
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
            sum += (idx + 1) * Number(line[1]);
        }

        console.log(sum);
    }
});
