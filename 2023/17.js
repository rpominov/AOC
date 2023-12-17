const input = `2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533`;

const map = input.split("\n").map((line) => line.split("").map(Number));

// we assume a square
const size = map.length;

const opposite = { ">": "<", "<": ">", "^": "v", v: "^" };

const getConnectionsForward = ({ x, y, history }) => {
  const prev = history[history.length - 1];

  return [">", "v", "<", "^"]
    .map((move) => {
      if (opposite[prev] === move) {
        return null;
      }

      const newHistory = prev === move ? history + move : move;

      if (newHistory.length > 3) {
        return null;
      }

      const [dx, dy] =
        move === ">"
          ? [1, 0]
          : move === "<"
          ? [-1, 0]
          : move === "^"
          ? [0, -1]
          : [0, 1];

      const newX = x + dx;
      const newY = y + dy;

      if (newX < 0 || newX >= size || newY < 0 || newY >= size) {
        return null;
      }

      return { x: newX, y: newY, history: newHistory };
    })
    .filter(Boolean);
};

const forwardConnections = new Map();

const toProcess = [{ x: 0, y: 0, history: ">" }];
const processed = new Set();

const itemToKey = ({ x, y, history }) => `${x},${y},${history}`;

const keyToItem = (key) => {
  const [x, y, history] = key.split(",");
  return { x: Number(x), y: Number(y), history };
};

while (toProcess.length > 0) {
  const item = toProcess.pop();
  const itemKey = itemToKey(item);
  processed.add(itemKey);

  const connections = getConnectionsForward(item);

  forwardConnections.set(itemKey, connections);

  for (const connection of connections) {
    const connectionKey = itemToKey(connection);
    if (!processed.has(connectionKey)) {
      toProcess.push(connection);
    }
  }
}

const backwardConnections = new Map();

for (const [key, connections] of forwardConnections.entries()) {
  const from = keyToItem(key);
  for (const connection of connections) {
    const connectionKey = itemToKey(connection);
    const list = backwardConnections.get(connectionKey) || [];
    list.push(from);
    backwardConnections.set(connectionKey, list);
  }
}

const finishNodes = [...backwardConnections.keys()].filter((key) => {
  const [x, y] = key.split(",").map(Number);
  return x === size - 1 && y === size - 1;
});

const finalCosts = new Map();
const minCosts = new Map();

finishNodes.forEach((key) => {
  finalCosts.set(key, map[size - 1][size - 1]);
});

const getBareMinimumCost = (item) => {
  return map[item.y][item.x] + map[size - 1][size - 1];
};

const getCost = (item) => {
  const key = itemToKey(item);

  if (finalCosts.has(key)) {
    return { isFinal: true, value: finalCosts.get(key) };
  }

  if (minCosts.has(key)) {
    return { isFinal: false, value: minCosts.get(key) };
  }

  return {
    isFinal: false,
    value: getBareMinimumCost(item),
  };
};

const processItem = (item) => {
  const key = itemToKey(item);
  const connections = forwardConnections.get(key);

  const costs = connections.map(getCost);

  costs.sort((a, b) => {
    if (a.value === b.value) {
      return a.isFinal ? -1 : 1;
    }
    return a.value - b.value;
  });

  const best = costs[0];

  if (best.isFinal) {
    finalCosts.set(key, best.value + map[item.y][item.x]);
    return;
  }

  minCosts.set(key, best.value + map[item.y][item.x]);
};

const processAll = () => {
  for (const key of forwardConnections.keys()) {
    if (finalCosts.has(key)) {
      continue;
    }
    processItem(keyToItem(key));
  }
};

console.log("nodes", forwardConnections.size);
console.log(
  "connections",
  [...forwardConnections.values()].reduce((a, b) => a + b.length, 0)
);

while (!finalCosts.has("1,0,>")) {
  processAll();
  console.log(
    "%",
    Math.round((finalCosts.size / forwardConnections.size) * 100)
  );
}

console.log("Result 1:", finalCosts.get("1,0,>"));
