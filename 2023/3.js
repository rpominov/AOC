const input = `467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`;

const numbers = input
  .split("\n")
  .map((line, i) =>
    [...line.matchAll(/\d+/g)].map((x) => ({
      value: Number(x[0]),
      start: x.index,
      end: x.index + x[0].length - 1,
      line: i,
    }))
  )
  .flat();

const symbols = input
  .split("\n")
  .map((line, i) =>
    [...line.matchAll(/[^\d\.]/g)].map((x) => ({
      value: x[0],
      start: x.index,
      line: i,
    }))
  )
  .flat();

const isAdjectent = (number, symbol) =>
  symbol.line >= number.line - 1 &&
  symbol.line <= number.line + 1 &&
  symbol.start >= number.start - 1 &&
  symbol.start <= number.end + 1;

console.log(
  "Result 1:",
  numbers
    .filter((number) => symbols.some((symbol) => isAdjectent(number, symbol)))
    .reduce((acc, { value }) => acc + value, 0)
);

console.log(
  "Result 2:",
  symbols
    .map((symbol) => ({
      ...symbol,
      numbers: numbers.filter((number) => isAdjectent(number, symbol)),
    }))
    .filter(({ value, numbers }) => value === "*" && numbers.length === 2)
    .map(({ numbers }) => numbers[0].value * numbers[1].value)
    .reduce((acc, value) => acc + value, 0)
);
