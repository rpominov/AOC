const input = `19999
19999
19999
19999
11111`;

const map = input.split("\n").map((line) => line.split("").map(Number));

const height = map.length;
const width = map[0].length;

const opposite = { ">": "<", "<": ">", "^": "v", v: "^" };

const getConnectionsForward = ({ x, y, history }) => {
  const prev = history[history.length - 1];

  return [">", "v", "<", "^"]
    .map((move) => {
      if (opposite[prev] === move) {
        return null;
      }

      if (move !== prev && history.length < 4) {
        return null;
      }

      const newHistory = prev === move ? history + move : move;

      if (newHistory.length > 10) {
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

      if (newX < 0 || newX >= width || newY < 0 || newY >= height) {
        return null;
      }

      if (newX === width - 1 && newY === height - 1 && newHistory.length < 4) {
        return null;
      }

      return { x: newX, y: newY, history: newHistory };
    })
    .filter(Boolean);
};

const forwardConnections = new Map();

// NOTE: Unfinished code! You need to rut it 2 times with both of these options, and choose the smaller result!!!
//
const firstItem = { x: 0, y: 1, history: "v" };
// const firstItem = { x: 1, y: 0, history: ">" };

const toProcess = [firstItem];
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

// let removed = 1;

// while (removed > 0) {
//   removed = 0;
//   const toRemove = [];
//   for (const [key, connections] of forwardConnections.entries()) {
//     if (connections.length === 0) {
//       forwardConnections.delete(key);
//       for (const arr of forwardConnections.values()) {
//         const index = arr.findIndex((item) => itemToKey(item) === key);
//         if (index >= 0) {
//           arr.splice(index, 1);
//         }
//       }
//       removed++;
//     }
//   }
// }

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
  return x === width - 1 && y === height - 1;
});

const finalCosts = new Map();
const minCosts = new Map();

finishNodes.forEach((key) => {
  finalCosts.set(key, map[height - 1][width - 1]);
});

const getBareMinimumCost = (item) => {
  return map[item.y][item.x] + map[height - 1][width - 1];
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

  if (connections.length === 0) {
    finalCosts.set(key, Infinity);
    return;
  }

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

let nodes = [...forwardConnections.keys()];

const processAll = () => {
  nodes = nodes.filter((key) => !finalCosts.has(key));
  for (const key of nodes) {
    processItem(keyToItem(key));
  }
};

console.log("nodes", forwardConnections.size);
console.log(
  "connections",
  [...forwardConnections.values()].reduce((a, b) => a + b.length, 0)
);

while (!finalCosts.has(itemToKey(firstItem))) {
  processAll();
  console.log(
    "%",
    Math.round((finalCosts.size / forwardConnections.size) * 100)
  );
}

const finalPath = [itemToKey(firstItem)];

while (!finalPath.at(-1).startsWith(`${width - 1},${height - 1},`)) {
  const last = finalPath.at(-1);
  const connections = forwardConnections.get(last);

  if (connections.length === 0) {
    console.log("No connections!!! (bug, bug, bug)");
    console.log(finalCosts.get(last));
    break;
  }

  const withCosts = connections.map((item) => {
    const cost = finalCosts.get(itemToKey(item)) ?? Infinity;
    return { item, cost };
  });

  // console.log(withCosts);

  withCosts.sort((a, b) => a.cost - b.cost);
  finalPath.push(itemToKey(withCosts[0].item));
}

const finalPathMap = new Map(
  finalPath.map((key) => {
    const { x, y, history } = keyToItem(key);
    return [`${x},${y}`, history[history.length - 1]];
  })
);

console.log(finalPath);

console.log(
  map
    .map((row, y) =>
      row
        .map((cell, x) => {
          if (finalPathMap.has(`${x},${y}`)) {
            return finalPathMap.get(`${x},${y}`);
          }

          return cell;
        })
        .join("")
    )
    .join("\n")
);

console.log("Result 2", finalCosts.get(itemToKey(firstItem)));
