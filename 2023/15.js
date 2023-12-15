const input = `rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7`;

const getHash = (x) =>
  x.split("").reduce((acc, c) => ((acc + c.charCodeAt(0)) * 17) % 256, 0);

const boxes = Array.from({ length: 256 }, () => []);

for (const instruction of input.split(",")) {
  if (instruction.indexOf("=") !== -1) {
    const [label, focusLength] = instruction.split("=");
    const hash = getHash(label);
    const box = boxes[hash];
    const existing = box.find((x) => x.label === label);
    if (existing) {
      existing.focusLength = focusLength;
    } else {
      box.push({ label, focusLength });
    }
  } else {
    const [label] = instruction.split("-");
    const hash = getHash(label);
    boxes[hash] = boxes[hash].filter((x) => x.label !== label);
  }
}

console.log(
  boxes
    .map((x, i) => ({ lenses: x, box: i }))
    .filter(({ lenses }) => lenses.length > 0)
    .map(({ lenses, box }) =>
      lenses.map(({ focusLength }, i) => (box + 1) * (i + 1) * focusLength)
    )
    .flat()
    .reduce((a, b) => a + b, 0)
);
