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
            let maxRed = 0;
            let maxGreen = 0;
            let maxBlue = 0
            
            for (const draw of draws) {
                const matches = draw.split(", ");

                for (let match of matches) {
                    match = match.split(" ")
                    const count = Number(match[0]);
                    const color = match[1];

                    if (color == "red" && count > maxRed) {
                        maxRed = count;
                    } else if (color == "green" && count > maxGreen) {
                        maxGreen = count;
                    } else if (color == "blue" && count > maxBlue) {
                        maxBlue = count
                    }
                }
            }   

            sum += maxRed * maxGreen * maxBlue

        }

        console.log(sum);
    }
});
