const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const strings = text.substring(0, text.length - 1).split(",");
        const boxes = Array(256).fill().map(_ => []);

        stringLoop:
        for (const string of strings) {
            let box = 0;
            let label = "";

            let idx = 0;

            for (; string[idx] != "=" && string[idx] != "-"; idx++) {
                box += string.charCodeAt(idx);
                box *= 17;
                box %= 256;

                label += string[idx];
            }

            // This could absolutely be made more efficient, but the input is small enough, okay?
            for (const [lensIdx, [lensLabel, _]] of boxes[box].entries()) {
                if (lensLabel == label) {
                    if (string[idx] == "=") {
                        boxes[box][lensIdx][1] = Number(string[idx + 1]);
                        continue stringLoop;
                    } else {
                        boxes[box].splice(lensIdx, 1);
                        continue stringLoop;
                    }
                }
            }
             
            if (string[idx] == "=") {
                boxes[box].push([label, Number(string[idx + 1])]);
            }
        }

        let sum = 0;

        for (const [boxIdx, box] of boxes.entries()) {
            for (const [lensIdx, [_, focalLength]] of box.entries()) {
                sum += (boxIdx + 1) * (lensIdx + 1) * focalLength;
            }
        }

        console.log(sum);
    }
});
