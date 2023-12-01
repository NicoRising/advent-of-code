const fs = require('node:fs');

function reverse(str) {
    return str.split("").reverse().join("");
}

function wordToNum(num) {
    if (num == "zero") {
        return 0;
    } else if (num == "one") {
        return 1;
    } else if (num == "two") {
        return 2;
    } else if (num == "three") {
        return 3;
    } else if (num == "four") {
        return 4;
    } else if (num == "five") {
        return 5;
    } else if (num == "six") {
        return 6;
    } else if (num == "seven") {
        return 7;
    } else if (num == "eight") {
        return 8;
    } else if (num == "nine") {
        return 9;
    } else {
        return Number(num);
    };
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const lines = text.split(/\n/).slice(0, -1);
        let sum = 0

        for (const line of lines) {
            const forward_regex = /\d|zero|one|two|three|four|five|six|seven|eight|nine/;
            const backward_regex = /\d|orez|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/;

            let first = line.match(forward_regex)[0];
            let last = reverse(reverse(line).match(backward_regex)[0]);

            sum += wordToNum(first) * 10 + wordToNum(last);
        }

        console.log(sum);
    }
});
