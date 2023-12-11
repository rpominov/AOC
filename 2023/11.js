const input = `...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....`;

const map = input.split("\n").map((line) => line.split(""));

class Coordinate {
  constructor(x, y) {
    this.originalX = x;
    this.originalY = y;
    this.x = x;
    this.y = y;
  }
  distanceTo(other) {
    return Math.abs(this.x - other.x) + Math.abs(this.y - other.y);
  }
}

const getPairs = (arr) => {
  const pairs = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      pairs.push([arr[i], arr[j]]);
    }
  }
  return pairs;
};

const galaxies = [];

map.forEach((line, y) => {
  line.forEach((cell, x) => {
    if (cell === "#") {
      galaxies.push(new Coordinate(x, y));
    }
  });
});

const expandingRows = map
  .map((row, y) => ({
    y,
    isExpanding: !row.includes("#"),
  }))
  .filter(({ isExpanding }) => isExpanding)
  .map(({ y }) => y);

const expandingColumns = map[0]
  .map((_, x) => ({
    x,
    isExpanding: !map.some((row) => row[x] === "#"),
  }))
  .filter(({ isExpanding }) => isExpanding)
  .map(({ x }) => x);

const expandBy = (factor) => {
  galaxies.forEach((galaxy) => {
    galaxy.x = galaxy.originalX;
    galaxy.y = galaxy.originalY;
  });

  expandingRows.forEach((y) => {
    galaxies.forEach((galaxy) => {
      if (galaxy.originalY > y) {
        galaxy.y += factor - 1;
      }
    });
  });

  expandingColumns.forEach((x) => {
    galaxies.forEach((galaxy) => {
      if (galaxy.originalX > x) {
        galaxy.x += factor - 1;
      }
    });
  });
};

expandBy(2);

console.log(
  "Result 1:",
  getPairs(galaxies)
    .map(([a, b]) => a.distanceTo(b))
    .reduce((a, b) => a + b, 0)
);

expandBy(1000000);

console.log(
  "Result 2:",
  getPairs(galaxies)
    .map(([a, b]) => a.distanceTo(b))
    .reduce((a, b) => a + b, 0)
);
