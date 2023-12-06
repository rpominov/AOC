const input = `Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11`;

const parsed = input.split("\n").map((line) =>
  line
    .split(": ")[1]
    .split(" | ")
    .map((x) =>
      x
        .split(" ")
        .filter((x) => x !== "")
        .map(Number)
    )
);

console.log(
  "Result 1:",
  parsed
    .map(([winning, mine]) => {
      const count = mine.filter((x) => winning.includes(x)).length;
      return count === 0 ? 0 : 2 ** (count - 1);
    })
    .reduce((a, x) => a + x, 0)
);

const additions = [];

parsed.reverse().forEach(([winning, mine]) => {
  additions.unshift(
    additions
      .slice(0, mine.filter((x) => winning.includes(x)).length)
      .reduce((a, x) => a + x, 1)
  );
});

console.log(
  "Result 2:",
  additions.reduce((a, x) => a + x, 0)
);
