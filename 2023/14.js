const input = `O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....`;

class RocksMap {
  constructor(input) {
    this.data = input.split("\n").map((line) => line.split(""));
    this.size = this.data.length; // we assume a square
  }

  print(angle = 0) {
    let result = "";
    for (let y = 0; y < this.size; y++) {
      for (let x = 0; x < this.size; x++) {
        result += this.get(x, y, angle);
      }
      result += "\n";
    }
    console.log(result);
  }

  // get value as if the map is rotated by angle degrees clockwise
  get(x, y, angle = 0) {
    switch (angle) {
      case 0:
        return this.data[y][x];
      case 90:
        return this.data[this.size - x - 1][y];
      case 180:
        return this.data[this.size - y - 1][this.size - x - 1];
      case 270:
        return this.data[x][this.size - y - 1];
      default:
        throw new Error(`Invalid angle: ${angle}`);
    }
  }

  // set value as if the map is rotated by angle degrees clockwise
  set(x, y, value, angle = 0) {
    switch (angle) {
      case 0:
        this.data[y][x] = value;
        break;
      case 90:
        this.data[this.size - x - 1][y] = value;
        break;
      case 180:
        this.data[this.size - y - 1][this.size - x - 1] = value;
        break;
      case 270:
        this.data[x][this.size - y - 1] = value;
        break;
      default:
        throw new Error(`Invalid angle: ${angle}`);
    }
  }

  // roll to the top as if the map is rotated by angle degrees clockwise
  roll(angle = 0) {
    // for each column
    for (let x = 0; x < this.size; x++) {
      let firstEmpty = -1;
      for (let y = 0; y < this.size; y++) {
        const value = this.get(x, y, angle);
        if (value === ".") {
          if (firstEmpty === -1) {
            firstEmpty = y;
          }
          continue;
        }
        if (value === "#") {
          firstEmpty = -1;
          continue;
        }
        if (firstEmpty === -1) {
          continue;
        }
        this.set(x, firstEmpty, "O", angle);
        this.set(x, y, ".", angle);
        firstEmpty++;
      }
    }
  }

  tiltNorth() {
    this.roll(0);
  }

  tiltEast() {
    this.roll(270);
  }

  tiltSouth() {
    this.roll(180);
  }

  tiltWest() {
    this.roll(90);
  }

  cycle() {
    this.tiltNorth();
    this.tiltWest();
    this.tiltSouth();
    this.tiltEast();
  }

  // get load of the top beam as if the map is rotated by angle degrees clockwise
  getLoad(angle) {
    let load = 0;
    for (let x = 0; x < this.size; x++) {
      for (let y = 0; y < this.size; y++) {
        if (this.get(x, y, angle) === "O") {
          load += this.size - y;
        }
      }
    }
    return load;
  }

  toString() {
    return this.data.map((line) => line.join("")).join("\n");
  }
}

const map = new RocksMap(input);

map.tiltNorth();

console.log("Result 1:", map.getLoad());

// finish the first cycle
map.tiltWest();
map.tiltSouth();
map.tiltEast();

const loopDetection = new Map();
let loopsSkipped = false;

// do remaining cycles
for (let i = 1; i < 1000000000; i++) {
  map.cycle();

  if (!loopsSkipped) {
    const key = map.toString();
    if (loopDetection.has(key)) {
      const previousI = loopDetection.get(key);
      const loopSize = i - previousI;
      const remainingFullLoops = Math.floor((1000000000 - i) / loopSize);
      i += remainingFullLoops * loopSize;
      loopsSkipped = true;
    } else {
      loopDetection.set(key, i);
    }
  }
}

console.log("Result 2:", map.getLoad());
