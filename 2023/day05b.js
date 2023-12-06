const fs = require("node:fs");

// Remaps a range based on a ranges in the next layer
function mergeRanges(currRange, nextLayer) {
    const [sourceStartA, sourceEndA, diffA] = currRange;
    const destStartA = sourceStartA + diffA;
    const destEndA = sourceEndA + diffA;

    for (const [sourceStartB, sourceEndB, diffB] of nextLayer) {
        const beforeLength = Math.max(sourceStartB - destStartA, 0);
        const afterLength = Math.max(destEndA - sourceEndB, 0);
        const overlap = destEndA - destStartA - beforeLength - afterLength;

        if (overlap > 0) {
            let ranges = [];

            const overlapStart = Math.max(destStartA, sourceStartB);
            const overlapEnd = Math.min(destEndA, sourceEndB);

            const overlapRange = [overlapStart - diffA, overlapEnd - diffA, diffA + diffB];
            ranges.push(overlapRange);

            if (beforeLength > 0) {
                // Merge the left bit that didn't overlap with this range with the next map
                beforeRange = [sourceStartA, sourceStartA + beforeLength, diffA];
                ranges = ranges.concat(mergeRanges(beforeRange, nextLayer));
            }

            if (afterLength > 0) {
                // Merge the right bit that didn't overlap with this range with the next map
                afterRange = [sourceEndA - afterLength, sourceEndA, diffA];
                ranges = ranges.concat(mergeRanges(afterRange, nextLayer));
            }

            return ranges;
        }
    }

    // If the range never overlapped with the next map, then map 1:1
    return [currRange];
}

fs.readFile("input.txt", "utf8", (err, text) => {
    if (err) {
        console.error(err);
    } else {
        const blocks = text.substring(0, text.length - 1).split("\n\n");
        const gardenLayers = [];

        // Assumes blocks are ordered in the sequence they're applied
        for (const block of blocks) {
            const ranges = [];

            if (block.startsWith("seeds")) {
                for (let pair of block.match(/\d+ \d+/g)) {
                    // Turn the seed range into a valid range
                    pair = pair.split(" ").map(Number);
                    pair[1] += pair[0];
                    pair.push(0);

                    ranges.push(pair);
                }
            } else {
                const lines = block.split("\n");

                for (const line of lines.slice(1)) {
                    const [destStart, sourceStart, length] = line.match(/\d+/g).map(Number);
                    const sourceEnd = sourceStart + length;
                    const diff = destStart - sourceStart;

                    ranges.push([sourceStart, sourceEnd, diff]);
                }
            }

            gardenLayers.push(ranges);
        }

        // Merge the seed ranges downward through each layer 
        const simplifiedMap = gardenLayers.reduce((mergedLayers, currLayer) => {
            let merged = [];

            for (const range of mergedLayers) {
                merged = merged.concat(mergeRanges(range, currLayer));
            }

            return merged;
        });

        // Sort by the output of the lower bound of a range when mapped
        simplifiedMap.sort((a, b) => a[0] + a[2] - b[0] - b[2]);

        // Take the lowest range and apply the mapping to the lower bound
        console.log(simplifiedMap[0][0] + simplifiedMap[0][2]);
    }
});
