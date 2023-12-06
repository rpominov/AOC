const input = `Time:      7  15   30
Distance:  9  40  200`;

const higherInt = (x) => (Math.ceil(x) === x ? x + 1 : Math.ceil(x));
const lowerInt = (x) => (Math.floor(x) === x ? x - 1 : Math.floor(x));

const getSolutionsCount = (time, recordDistance) => {
  const ds = Math.sqrt(time ** 2 - recordDistance * 4);
  return lowerInt((0 - time - ds) / -2) - higherInt((0 - time + ds) / -2) + 1;
};

const times = input
  .split("\n")[0]
  .split(":")[1]
  .trim()
  .split(/\s+/)
  .map(Number);

const distances = input
  .split("\n")[1]
  .split(":")[1]
  .trim()
  .split(/\s+/)
  .map(Number);

console.log(
  "Result 1:",
  times
    .map((time, i) => getSolutionsCount(time, distances[i]))
    .reduce((a, b) => a * b, 1)
);

const time = Number(
  input.split("\n")[0].split(":")[1].trim().split(/\s+/).join("")
);

const distance = Number(
  input.split("\n")[1].split(":")[1].trim().split(/\s+/).join("")
);

console.log("Result 2:", getSolutionsCount(time, distance));
