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


        let loop = [start, curr];
        const rows = new Map();
        rows.set(start[0], new Set([start[1]]));

        while (!samePipe(loop.at(-1), loop[0])) {
            curr = loop.at(-1);
            loop.push(nextPipe(curr, loop.at(-2), pipes));

            if (rows.has(curr[0])) {
                rows.get(curr[0]).add(curr[1]);
            } else {
                rows.set(curr[0], new Set([curr[1]]));
            }
        }

        loop = loop.slice(0, -1);

        for (const type of "|-LJ7F") {
            pipes[start[0]] = pipes[start[0]].substring(0, start[1]) + type +
                              pipes[start[0]].substring(start[1] + 1);

            if (samePipe(nextPipe(start, loop[1], pipes), loop.at(-1)) &&
                samePipe(nextPipe(start, loop.at(-1), pipes), loop[1])) {

                break;
            }
        }

        let enclosed = 0;

        for (const [row, cols] of rows.entries()) {
            let inside = false;
            let onPipeBottom = false;
            let onPipeTop = false;

            for (let col = 0; col < pipes[row].length; col++) {
                if (cols.has(col)) {
                    if (pipes[row][col] == '|') {
                        inside = !inside;
                    } else if (pipes[row][col] == "L") {
                        onPipeBottom = true;
                    } else if (pipes[row][col] == "F") {
                        onPipeTop = true;
                    } else if (pipes[row][col] == "J") {
                        if (onPipeTop) {
                            inside = !inside;
                        }

                        onPipeTop = false;
                        onPipeBottom = false;
                    } else if (pipes[row][col] == "7") {
                        if (onPipeBottom) {
                            inside = !inside;
                        }

                        onPipeBottom = false;
                        onPipeTop = false;
                    }
                } else if (inside && !onPipeBottom && !onPipeTop) {
                    enclosed++;
                }
            }
        }

        console.log(enclosed);
    }
});
