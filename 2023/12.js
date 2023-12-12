const input = `???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1`;

class Row {
  constructor(input) {
    this.input = input;
    const [cells, check] = input.split(" ");
    this.cells = cells.split("");
    this.check = check;
  }

  unfold() {
    const [cells, check] = this.input.split(" ");
    this.cells = [cells, cells, cells, cells, cells].join("?").split("");
    this.check = [check, check, check, check, check].join(",");
  }

  getArrangementsCount() {
    const memo = new Map();
    const getCount = (cells, check) => {
      const key = cells + check;
      if (memo.has(key)) {
        return memo.get(key);
      }
      const result = getCount_(cells, check);
      memo.set(key, result);
      return result;
    };
    const getCount_ = (cells, check) => {
      if (cells === "." && check === "") {
        return 1;
      }
      if (cells === "#" && check === "1") {
        return 1;
      }
      if (cells === "?" && (check === "1" || check === "")) {
        return 1;
      }
      if (cells.length === 1) {
        return 0;
      }
      const first = cells[0];
      if (first === "?") {
        const rest = cells.slice(1);
        return getCount("#" + rest, check) + getCount("." + rest, check);
      }
      if (first === ".") {
        return getCount(cells.slice(1), check);
      }
      if (check.length === 0) {
        return 0;
      }

      const checksParsed = check.split(",").map(Number);
      const firstCheck = checksParsed[0];

      const second = cells[1];

      const expectedSecond = firstCheck === 1 ? "." : "#";

      if (second !== expectedSecond && second !== "?") {
        return 0;
      }

      return getCount(
        expectedSecond + cells.slice(2),
        (firstCheck === 1
          ? checksParsed.slice(1)
          : [firstCheck - 1, ...checksParsed.slice(1)]
        ).join(",")
      );
    };

    return getCount(this.cells.join(""), this.check);
  }
}

console.log(
  "Result 1:",
  input
    .split("\n")
    .map((line, i, arr) => {
      const row = new Row(line);
      return row.getArrangementsCount();
    })
    .reduce((a, b) => a + b, 0)
);

console.log(
  "Result 2:",
  input
    .split("\n")
    .map((line, i, arr) => {
      const row = new Row(line);
      row.unfold();
      return row.getArrangementsCount();
    })
    .reduce((a, b) => a + b, 0)
);
