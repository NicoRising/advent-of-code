const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const [time, distance] = text.replace(/ /g, "").match(/\d+/g);
        // OK, now I'll use the quadratic equation
        console.log(Math.floor(Math.sqrt(time * time - 4 * distance)));
    }
});
