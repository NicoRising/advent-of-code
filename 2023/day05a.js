const fs = require("node:fs");

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const blocks = text.substring(0, text.length - 1).split("\n\n");

        let seeds;
        const gardenLayers = [];

        // Assumes blocks are ordered in the sequence they're applied
        for (const block of blocks) {
            if (block.startsWith("seeds")) {
                seeds = block.match(/\d+/g).map(Number);
            } else {
                const lines = block.split("\n");
                const ranges = [];

                for (const line of lines.slice(1)) {
                    const [destStart, sourceStart, length] = line.match(/\d+/g).map(Number);
                    const sourceEnd = sourceStart + length;
                    const diff = destStart - sourceStart;

                    ranges.push([sourceStart, sourceEnd, diff]);
                }

                gardenLayers.push(ranges);
            }
        }

        for (const layer of gardenLayers) {
            for (const [idx, seed] of seeds.entries()) {
                for (const [sourceStart, sourceEnd, diff] of layer) {
                    if (seed >= sourceStart && seed < sourceEnd) {
                        seeds[idx] += diff;
                    }
                }
            }
        }

        console.log(Math.min(...seeds));
    }
});
