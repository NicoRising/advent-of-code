const fs = require("node:fs");

function samePipe(a, b) {
    return a[0] == b[0] && a[1] == b[1];
}

function nextPipe(curr, last, pipes) {
    const currChar = pipes[curr[0]][curr[1]];
    let neighbors;

    switch (currChar) {
        case "|":
            neighbors = [[curr[0] - 1, curr[1]], [curr[0] + 1, curr[1]]];
            break;
        case "-":
            neighbors = [[curr[0], curr[1] - 1], [curr[0], curr[1] + 1]];
            break;
        case "L":
            neighbors = [[curr[0] - 1, curr[1]], [curr[0], curr[1] + 1]];
            break;
        case "J":
            neighbors = [[curr[0] - 1, curr[1]], [curr[0], curr[1] - 1]];
            break;
        case "7":
            neighbors = [[curr[0], curr[1] - 1], [curr[0] + 1, curr[1]]];
            break;
        case "F":
            neighbors = [[curr[0] + 1, curr[1]], [curr[0], curr[1] + 1]];
    }

    return samePipe(neighbors[0], last) ? neighbors[1] : neighbors[0];
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const pipes = text.split("\n").slice(0, -1);
        let start;

        for (const [row, line] of pipes.entries()) {
            const col = line.indexOf("S");

            if (col != -1) {
                start = [row, col];
            }
        }

        let curr;

        if (start[0] - 1 >= 0 && /[|7F]/.test(pipes[start[0] - 1][start[1]])) {
            curr = [start[0] - 1, start[1]];
        } else if (start[1] - 1 >= 0 && /[-LF]/.test(pipes[start[0]][start[1] - 1])) {
            curr = [start[0], start[1] - 1];
        } else if (start[0] + 1 < pipes.length && /[|LJ]/.test(pipes[start[0] + 1][start[1]])) {
            curr = [start[0] + 1, start[1]];
        } else if (start[1] + 1 < pipes[0].length && /[-J7]/.test(pipes[start[0] + 1][start[1]])) {
            curr = [start[0], start[1] + 1];
        }

        let last = [...start];
        let steps = 1;

        while (!samePipe(curr, start)) {
            const nextLast = curr;
            curr = nextPipe(curr, last, pipes);
            last = nextLast;
            steps++;
        }

        console.log(steps / 2);
    }
});
