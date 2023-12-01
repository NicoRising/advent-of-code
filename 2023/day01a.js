const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split(/\n/).slice(0, -1);
        let sum = 0;

        for (const line of lines) {
            const nums = line.match(/\d/g);
            sum += Number(nums[0]) * 10 + Number(nums[nums.length - 1]);
        }

        console.log(sum);
    }
});
