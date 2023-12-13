const input = `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#`;

class Pattern {
  constructor(input) {
    this.input = input;
    this.rows = input.split("\n");
    this.columns = this.rows[0]
      .split("")
      .map((_, i) => this.rows.map((row) => row[i]).join(""));
  }

  flipNext() {
    if (this.prevFlip === undefined) {
      this.prevFlip = -1;
      this.originalRows = this.rows;
      this.originalColumns = this.columns;
    }

    this.prevFlip++;
    this.rows = this.originalRows.slice();
    this.columns = this.originalColumns.slice();

    const row = Math.floor(this.prevFlip / this.columns.length);
    const column = this.prevFlip % this.rows[0].length;

    const newValue = this.rows[row][column] === "." ? "#" : ".";

    this.rows[row] =
      this.rows[row].slice(0, column) +
      newValue +
      this.rows[row].slice(column + 1);

    this.columns[column] =
      this.columns[column].slice(0, row) +
      newValue +
      this.columns[column].slice(row + 1);
  }
}

const findReflection = (rows) => {
  let results = [];
  for (let i = 1; i < rows.length; i++) {
    let found = true;
    for (let j = i, k = i - 1; j < rows.length && k >= 0; j++, k--) {
      if (rows[j] !== rows[k]) {
        found = false;
        break;
      }
    }
    if (found) {
      results.push(i);
    }
  }

  return results.length === 0 ? 0 : results.length === 1 ? results[0] : results;
};

const parsed = input.split("\n\n").map((pattern) => new Pattern(pattern));

console.log(
  "Result 1:",
  [
    ...parsed.map(({ rows }) => findReflection(rows) * 100),
    ...parsed.map(({ columns }) => findReflection(columns)),
  ].reduce((a, b) => a + b, 0)
);

console.log(
  "Result 2:",
  parsed
    .map((pattern) => {
      const rowsRelfectionOrig = findReflection(pattern.rows);
      const collumnsReflectionOrig = findReflection(pattern.columns);

      if (
        typeof rowsRelfectionOrig !== "number" ||
        typeof collumnsReflectionOrig !== "number"
      ) {
        throw new Error("more than one originally");
      }

      while (true) {
        pattern.flipNext();
        const rowsRelfection = findReflection(pattern.rows);
        if (rowsRelfection && rowsRelfection !== rowsRelfectionOrig) {
          const final = (
            typeof rowsRelfection === "number"
              ? [rowsRelfection]
              : rowsRelfection
          ).find((x) => x !== rowsRelfectionOrig);

          return final * 100;
        }
        const collumnsReflection = findReflection(pattern.columns);
        if (
          collumnsReflection &&
          collumnsReflection !== collumnsReflectionOrig
        ) {
          const final = (
            typeof collumnsReflection === "number"
              ? [collumnsReflection]
              : collumnsReflection
          ).find((x) => x !== collumnsReflectionOrig);

          return final;
        }
      }
    })
    .reduce((a, b) => a + b, 0)
);
