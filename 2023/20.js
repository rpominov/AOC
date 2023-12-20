class State {
  constructor() {
    this.state = new Set();
  }

  isOn(name) {
    return this.state.has(name);
  }

  flipOn(name) {
    if (this.state.has(name)) {
      this.state.delete(name);
    } else {
      this.state.add(name);
    }
  }

  getLast(nodeName, sourceName) {
    if (this.state.has(nodeName + "." + sourceName)) {
      return "high";
    }
    return "low";
  }

  setLast(nodeName, sourceName, value) {
    const key = nodeName + "." + sourceName;
    if (value === "high") {
      this.state.add(key);
    } else {
      this.state.delete(key);
    }
  }

  toString() {
    return [...this.state].sort().join("|");
  }
}

class Node {
  constructor(name, type) {
    this.name = name;
    this.type = type;
    this.inputs = [];
    this.outputs = [];
  }

  toString() {
    return (
      this.inputs.join(" ") +
      " >> " +
      this.type +
      this.name +
      " >> " +
      this.outputs.join(" ")
    );
  }

  registerInput(name) {
    this.inputs.push(name);
  }

  registerOutput(name) {
    this.outputs.push(name);
  }

  process(state, from, pulse) {
    if (this.watchHigh !== undefined && pulse === "high") {
      this.watchHigh(from);
    }

    if (this.type === "") {
      return pulse;
    }

    if (this.type === "%") {
      if (pulse === "high") {
        return null;
      }

      if (pulse === "low") {
        state.flipOn(this.name);
        return state.isOn(this.name) ? "high" : "low";
      }
    }

    if (this.type === "&") {
      state.setLast(this.name, from, pulse);
      let allHigh = true;
      for (const input of this.inputs) {
        if (state.getLast(this.name, input) !== "high") {
          allHigh = false;
          break;
        }
      }
      return allHigh ? "low" : "high";
    }
  }
}

const input = `broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a`;

const nodes = new Map();

input.split("\n").forEach((line) => {
  const [typeName, outputs] = line.split(" -> ");
  const [type, name] =
    typeName === "broadcaster"
      ? ["", typeName]
      : [typeName[0], typeName.slice(1)];
  const node = new Node(name, type);
  nodes.set(name, node);
  outputs.split(", ").forEach((output) => {
    node.registerOutput(output);
  });
});

[...nodes.values()].forEach((node) => {
  node.outputs.forEach((output) => {
    nodes.get(output)?.registerInput(node.name);
  });
});

let low = 0;
let high = 0;

const process = (state, from, to, pulse) => {
  const queue = [{ from, to, pulse }];

  let steps = 0;

  while (queue.length > 0) {
    steps++;

    const { from, to, pulse } = queue.shift();

    if (pulse === "high") {
      high++;
    } else {
      low++;
    }

    const node = nodes.get(to);

    if (node === undefined) {
      continue;
    }

    const result = node.process(state, from, pulse);

    if (result === null) {
      continue;
    }

    node.outputs.forEach((output) => {
      queue.push({ from: node.name, to: output, pulse: result });
    });
  }
};

let state = new State();
for (let i = 0; i < 1000; i++) {
  process(state, "button", "broadcaster", "low");
}
console.log("Result 1:", low * high);

// NOTE: The code below will not work with the test input!

state = new State();
let i = 0;

const prev = {};
const diffs = {};
nodes.get("hj").watchHigh = (from) => {
  const p = prev[from] || 0;
  prev[from] = i;
  const d = i - p;
  diffs[from] = d;

  // NOTE: unfinished code. To get "Result 2" take LCM of diffs
  console.log(i, diffs);
};

// 220k / s
for (; i < 10000000; i++) {
  process(state, "button", "broadcaster", "low");
}
