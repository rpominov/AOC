const input = `0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45`;

const parseInput = (input) =>
  input.split("\n").map((line) => line.split(" ").map(Number));

const getNext = (seq) => {
  if (seq.every((x) => x === 0)) {
    return 0;
  }
  return seq.at(-1) + getNext(seq.slice(0, -1).map((x, i) => seq[i + 1] - x));
};

console.log(
  "Result 1:",
  parseInput(input)
    .map(getNext)
    .reduce((a, b) => a + b, 0)
);

console.log(
  "Result 2:",
  parseInput(input)
    .map((seq) => getNext(seq.reverse()))
    .reduce((a, b) => a + b, 0)
);
