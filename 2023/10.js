const input = `.....
.S-7.
.|.|.
.L-J.
.....`;

class PointsSet {
  constructor() {
    this.set = new Set();
  }

  key(point) {
    return `${point.x},${point.y}`;
  }

  add(point) {
    this.set.add(this.key(point));
  }

  has(point) {
    return this.set.has(this.key(point));
  }

  size() {
    return this.set.size;
  }

  removeIntersection(otherSet) {
    for (const key of otherSet.set.values()) {
      this.set.delete(key);
    }
  }

  fill(boundary) {
    for (const point of this.set.values()) {
      const [x, y] = point.split(",").map(Number);
      const neighbor = new Point(x + 1, y);
      if (nodeAt(neighbor) != null && !boundary.has(neighbor)) {
        this.add(neighbor);
      }
    }
  }
}

class Point {
  constructor(x, y) {
    this.distance = 0;
    this.prev = null;
    this.x = x;
    this.y = y;

    this.visited = new PointsSet();
    this.seenToTheLeft = new PointsSet();
    this.seenToTheRight = new PointsSet();

    this.visited.add(this);
  }

  up() {
    this.prev = this.clone();
    this.distance++;
    this.y--;
    this.visited.add(this);
    this.seenToTheLeft.add(new Point(this.x - 1, this.y));
    this.seenToTheRight.add(new Point(this.x + 1, this.y));
    this.seenToTheLeft.add(new Point(this.prev.x - 1, this.prev.y));
    this.seenToTheRight.add(new Point(this.prev.x + 1, this.prev.y));
  }

  down() {
    this.prev = this.clone();
    this.distance++;
    this.y++;
    this.visited.add(this);
    this.seenToTheLeft.add(new Point(this.x + 1, this.y));
    this.seenToTheRight.add(new Point(this.x - 1, this.y));
    this.seenToTheLeft.add(new Point(this.prev.x + 1, this.prev.y));
    this.seenToTheRight.add(new Point(this.prev.x - 1, this.prev.y));
  }

  left() {
    this.prev = this.clone();
    this.distance++;
    this.x--;
    this.visited.add(this);
    this.seenToTheLeft.add(new Point(this.x, this.y + 1));
    this.seenToTheRight.add(new Point(this.x, this.y - 1));
    this.seenToTheLeft.add(new Point(this.prev.x, this.prev.y + 1));
    this.seenToTheRight.add(new Point(this.prev.x, this.prev.y - 1));
  }

  right() {
    this.prev = this.clone();
    this.distance++;
    this.x++;
    this.visited.add(this);
    this.seenToTheLeft.add(new Point(this.x, this.y - 1));
    this.seenToTheRight.add(new Point(this.x, this.y + 1));
    this.seenToTheLeft.add(new Point(this.prev.x, this.prev.y - 1));
    this.seenToTheRight.add(new Point(this.prev.x, this.prev.y + 1));
  }

  clone() {
    return new Point(this.x, this.y);
  }

  moveForward(currentNode) {
    if (currentNode === "." || currentNode === "S") {
      throw new Error("Can't interpret node");
    }
    if (currentNode === "|") {
      // came from up?
      if (this.prev.y < this.y) {
        this.down();
      } else {
        this.up();
      }
    }
    if (currentNode === "-") {
      // came from left?
      if (this.prev.x < this.x) {
        this.right();
      } else {
        this.left();
      }
    }
    if (currentNode === "L") {
      // came from up?
      if (this.prev.y < this.y) {
        this.right();
      } else {
        this.up();
      }
    }
    if (currentNode === "J") {
      // came from up?
      if (this.prev.y < this.y) {
        this.left();
      } else {
        this.up();
      }
    }
    if (currentNode === "7") {
      // came from down?
      if (this.prev.y > this.y) {
        this.left();
      } else {
        this.down();
      }
    }
    if (currentNode === "F") {
      // came from down?
      if (this.prev.y > this.y) {
        this.right();
      } else {
        this.down();
      }
    }
  }
}

const map = input.split("\n").map((line) => line.split(""));
const sY = map.findIndex((line) => line.includes("S"));
const sX = map[sY].findIndex((c) => c === "S");

const nodeAt = (point) => (map[point.y] || [])[point.x];

const walker = new Point(sX, sY);

const possibleDirections = ["up", "down", "left", "right"].filter(
  (direction) => {
    const clone = walker.clone();
    clone[direction]();
    const node = nodeAt(clone);
    if (!node) {
      return false;
    }
    return (
      (direction === "up" && ["|", "7", "F"].includes(node)) ||
      (direction === "down" && ["|", "L", "J"].includes(node)) ||
      (direction === "left" && ["-", "L", "F"].includes(node)) ||
      (direction === "right" && ["-", "7", "J"].includes(node))
    );
  }
);

walker[possibleDirections[0]]();

while (nodeAt(walker) !== "S") {
  walker.moveForward(nodeAt(walker));
}

console.log("Result 1:", walker.distance / 2);

walker.seenToTheLeft.removeIntersection(walker.visited);
walker.seenToTheLeft.fill(walker.visited);
walker.seenToTheRight.removeIntersection(walker.visited);
walker.seenToTheRight.fill(walker.visited);

console.log(
  "L:",
  walker.seenToTheLeft.size(),
  "R:",
  walker.seenToTheRight.size()
);

map.forEach((line, y) => {
  console.log(
    line
      .map((_, x) =>
        walker.seenToTheLeft.has(new Point(x, y))
          ? "L"
          : walker.seenToTheRight.has(new Point(x, y))
          ? "R"
          : walker.visited.has(new Point(x, y))
          ? "#"
          : "."
      )
      .join("")
  );
});
