const input = `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4`;

const seeds = input.split("\n")[0].split(": ")[1].split(" ").map(Number);

const maps = input
  .split("\n\n")
  .slice(1)
  .map((x) =>
    x
      .split("\n")
      .slice(1)
      .map((line) => line.split(" ").map(Number))
  );

console.log(
  "Result 1:",
  Math.min(
    ...Object.values(
      maps.reduce((acc, map) => {
        const result = {};
        for (const [source, dest] of Object.entries(acc)) {
          let newDest = dest;
          for (const [destStart, sourceStart, length] of map) {
            if (dest >= sourceStart && dest < sourceStart + length) {
              newDest = dest + (destStart - sourceStart);
              break;
            }
          }
          result[source] = newDest;
        }
        return result;
      }, Object.fromEntries(seeds.map((x) => [x, x])))
    )
  )
);

const getIntersection = (aStart, aLength, bStart, bLength) => {
  const aEnd = aStart + aLength;
  const bEnd = bStart + bLength;
  if (aStart < bStart) {
    return aEnd > bStart ? [bStart, Math.min(aEnd, bEnd) - bStart] : null;
  } else {
    return bEnd > aStart ? [aStart, Math.min(aEnd, bEnd) - aStart] : null;
  }
};

const remap = (base, mapping) => {
  // locked (already remapped)
  if (base[3]) {
    return [base];
  }

  const intersection = getIntersection(
    base[0],
    base[2],
    mapping[1],
    mapping[2]
  );

  if (!intersection) {
    return [base];
  }

  return [
    [base[0], base[1], intersection[0] - base[0]],
    [
      intersection[0] + (mapping[0] - mapping[1]),
      base[1] + intersection[0] - base[0],
      intersection[1],
      true, // locked
    ],
    [
      intersection[0] + intersection[1],
      base[1] + intersection[1],
      base[2] - intersection[1] - intersection[0] - base[0],
    ],
  ].filter((x) => x[2] > 0);
};

console.log(
  "Result 2:",
  Math.min(
    ...maps
      .reduce((base, map, i) => {
        let result = base.map((x) => x.slice(0, 3)); // remove locks

        for (const m of map) {
          result = result.flatMap((x) => remap(x, m));
        }

        return result;
      }, seeds.map((x, i) => (i % 2 === 0 ? [x, x, seeds[i + 1]] : null)).filter(Boolean))
      .map((x) => x[0])
  )
);
