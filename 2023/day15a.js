const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const strings = text.substring(0, text.length - 1).split(",");
        let sum = 0;

        for (const string of strings) {
            let val = 0;

            for (let idx = 0; idx < string.length; idx++) {
                val += string.charCodeAt(idx);
                val *= 17;
                val %= 256;
            }

            sum += val;
        }

        console.log(sum);
    }
});
