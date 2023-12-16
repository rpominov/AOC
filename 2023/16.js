const input = `.|...#....
|.-.#.....
.....|-...
........|.
..........
.........#
..../.##..
.-.-/..|..
.|....-|.#
..//.|....`;

// we assume a square grid
const size = input.split("\n").length;

const get = (x, y) => {
  x = Number(x);
  y = Number(y);

  if (x < 0 || x >= size || y < 0 || y >= size) return "outside";

  // +y is to account for newlines
  const char = input[y * size + x + y];

  // we've replaced the \ with # in the input, because \ is a special character in strings
  if (char === "#") return "\\";

  return char;
};

const joinSets = (set1, set2) => {
  const result = new Set(set1);
  for (const item of set2) {
    result.add(item);
  }
  return result;
};

const process = (enter) => {
  const toProcess = [enter];
  const processed = new Set();

  const addIfNotProcessed = (x, y, enteredFrom) => {
    const key = `${x},${y},${enteredFrom}`;
    if (!processed.has(key)) {
      toProcess.push(key);
    }
  };

  const visited = new Set();

  while (toProcess.length > 0) {
    let [x, y, enteredFrom] = toProcess.pop().split(",");
    x = Number(x);
    y = Number(y);
    processed.add(`${x},${y},${enteredFrom}`);
    const type = get(x, y);

    if (type === "outside") {
      continue;
    }

    visited.add(`${x},${y}`);

    if (enteredFrom === "left") {
      if (type === "." || type === "-") {
        addIfNotProcessed(x + 1, y, "left");
      } else if (type === "|") {
        addIfNotProcessed(x, y - 1, "below");
        addIfNotProcessed(x, y + 1, "above");
      } else if (type === "/") {
        addIfNotProcessed(x, y - 1, "below");
      } else if (type === "\\") {
        addIfNotProcessed(x, y + 1, "above");
      }
    } else if (enteredFrom === "right") {
      if (type === "." || type === "-") {
        addIfNotProcessed(x - 1, y, "right");
      } else if (type === "|") {
        addIfNotProcessed(x, y - 1, "below");
        addIfNotProcessed(x, y + 1, "above");
      } else if (type === "/") {
        addIfNotProcessed(x, y + 1, "above");
      } else if (type === "\\") {
        addIfNotProcessed(x, y - 1, "below");
      }
    } else if (enteredFrom === "above") {
      if (type === "." || type === "|") {
        addIfNotProcessed(x, y + 1, "above");
      } else if (type === "-") {
        addIfNotProcessed(x - 1, y, "right");
        addIfNotProcessed(x + 1, y, "left");
      } else if (type === "/") {
        addIfNotProcessed(x - 1, y, "right");
      } else if (type === "\\") {
        addIfNotProcessed(x + 1, y, "left");
      }
    } else if (enteredFrom === "below") {
      if (type === "." || type === "|") {
        addIfNotProcessed(x, y - 1, "below");
      } else if (type === "-") {
        addIfNotProcessed(x - 1, y, "right");
        addIfNotProcessed(x + 1, y, "left");
      } else if (type === "/") {
        addIfNotProcessed(x + 1, y, "left");
      } else if (type === "\\") {
        addIfNotProcessed(x - 1, y, "right");
      }
    }
  }

  return visited.size;
};

console.log("Result 1:", process("0,0,left"));

let max = 0;

for (let i = 0; i < size; i++) {
  const resultLeft = process(`0,${i},left`);
  const resultRight = process(`${size - 1},${i},right`);
  const resultAbove = process(`${i},0,above`);
  const resultBelow = process(`${i},${size - 1},below`);
  max = Math.max(max, resultLeft, resultRight, resultAbove, resultBelow);
}

console.log("Result 2:", max);
