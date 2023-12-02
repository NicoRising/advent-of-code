const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split(/\n/).slice(0, -1);
        let sum = 0;

        for (const [idx, line] of lines.entries()) {
            draws = line.substring(line.indexOf(":") + 2).split("; ");
            let impossible = false;
            
            for (const draw of draws) {
                const matches = draw.split(", ");

                for (let match of matches) {
                    match = match.split(" ")
                    const count = Number(match[0]);
                    const color = match[1];

                    if (color == "red" && count > 12) {
                        impossible = true
                        break
                    } else if (color == "green" && count > 13) {
                        impossible = true
                        break
                    } else if (color == "blue" && count > 14) {
                        impossible = true
                        break
                    }
                }
            }   

            if (!impossible) {
                sum += idx + 1;
            }
        }

        console.log(sum);
    }
});
