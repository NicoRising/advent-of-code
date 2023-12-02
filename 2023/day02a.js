const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split(/\n/).slice(0, -1);
        let sum = 0;

        lineLoop:
        for (const [idx, line] of lines.entries()) {
            draws = line.substring(line.indexOf(":") + 2).split("; ");
            
            for (const draw of draws) {
                const dice = draw.split(", ");

                for (const die of dice) {
                    let [count, color] = die.split(" ");
                    count = Number(count);

                    if (color == "red"   && count > 12 ||
                        color == "green" && count > 13 ||
                        color == "blue"  && count > 14) {
                        
                        continue lineLoop;
                    }
                }
            }

            sum += idx + 1;
        }

        console.log(sum);
    }
});
