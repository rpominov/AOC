const input = `RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)`;

const directions = input.split("\n")[0].split("");
const map = new Map();
for (const line of input.split("\n").slice(2)) {
  const [key, value] = line.split(" = ");
  const [L, R] = value.slice(1, -1).split(", ");
  map.set(key, { L, R });
}

let steps = 0;
let currentNode = "AAA";

while (currentNode !== "ZZZ") {
  const direction = directions[steps % directions.length];
  currentNode = map.get(currentNode)[direction];
  steps++;
}

console.log("Result 1:", steps);

const loops = [...map.keys()]
  .filter((key) => key.endsWith("A"))
  .map((currentNode) => {
    const loop = [];
    steps = 0;
    while (true) {
      const stepsMod = steps % directions.length;
      const current_position = currentNode + "_" + stepsMod;
      currentNode = map.get(currentNode)[directions[stepsMod]];
      steps++;

      if (loop.includes(current_position)) {
        return {
          loop,
          // real input happen to have only one **Z per loop
          zIndex: loop.map((x) => x.split("_")[0].endsWith("Z")).indexOf(true),
          start: loop.indexOf(current_position),
          current: 0,
        };
      }

      loop.push(current_position);
    }
  });

steps = 0;

while (true) {
  const stepsToZ = loops.map((loop) =>
    loop.current <= loop.zIndex
      ? loop.zIndex - loop.current
      : loop.loop.length - loop.current + loop.zIndex - loop.start
  );

  const maxStepsToZ = Math.max(...stepsToZ);

  if (maxStepsToZ === 0) {
    console.log("Result 2:", steps);
    break;
  }

  steps += maxStepsToZ;

  for (const loop of loops) {
    loop.current += maxStepsToZ;
    while (loop.current >= loop.loop.length) {
      loop.current = loop.start + (loop.current - loop.loop.length);
    }
  }
}
