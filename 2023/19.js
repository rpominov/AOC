const input = `px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}`;

class Range {
  constructor(min = 1, max = 4000) {
    this.min = min;
    this.max = max;
  }

  size() {
    return this.max - this.min + 1;
  }

  applyCondition(type, value) {
    // x < 100
    if (type === "<") {
      return new Range(this.min, Math.min(this.max, value - 1));
    }
    // x > 100
    if (type === ">") {
      return new Range(Math.max(this.min, value + 1), this.max);
    }
    throw new Error("Unknown type");
  }
}

const emptyRange = new Range(0, -1);

class XMASRange {
  constructor(
    x = new Range(),
    m = new Range(),
    a = new Range(),
    s = new Range()
  ) {
    this.x = x;
    this.m = m;
    this.a = a;
    this.s = s;
  }

  clone() {
    return new XMASRange(this.x, this.m, this.a, this.s);
  }

  applyCondition(variable, operator, value) {
    const result = this.clone();
    result[variable] = this[variable].applyCondition(operator, value);
    return result;
  }

  size() {
    return this.x.size() * this.m.size() * this.a.size() * this.s.size();
  }
}

const rulesRaw = {};

input
  .split("\n\n")[0]
  .split("\n")
  .forEach((line) => {
    const [name, conditions] = line.split("{");
    rulesRaw[name] = conditions.slice(0, -1).split(",");
  });

const reverse = (operator, value) => {
  // x < 100
  if (operator === "<") {
    // x > 99
    return [">", value - 1];
  }
  // x > 100
  if (operator === ">") {
    // x < 101
    return ["<", value + 1];
  }
};

const memo = new Map([
  ["R", []],
  ["A", [new XMASRange()]],
]);

const ruleToRanges = (rule) => {
  if (memo.has(rule)) {
    return memo.get(rule);
  }
  const conditions = rulesRaw[rule];

  let result = [];

  conditions.reverse();

  for (const condition of conditions) {
    if (condition.includes(":")) {
      const [rule, next] = condition.split(":");
      const variable = rule[0];
      const operator = rule[1];
      const value = Number(rule.slice(2));
      const reversed = reverse(operator, value);
      result = result.map((range) =>
        range.applyCondition(variable, ...reversed)
      );
      result.push(
        ...ruleToRanges(next).map((range) =>
          range.applyCondition(variable, operator, value)
        )
      );
      result = result.filter((range) => range.size() > 0);
    } else {
      result.push(...ruleToRanges(condition));
    }
  }

  memo.set(rule, result);
  return result;
};

const ranges = ruleToRanges("in");

const parts = input
  .split("\n\n")[1]
  .split("\n")
  .map((line) => {
    const part = {};
    line
      .slice(1, -1)
      .split(",")
      .forEach((pair) => {
        const [key, value] = pair.split("=");
        part[key] = Number(value);
      });
    return part;
  });

console.log(
  "Result 1:",
  parts
    .filter((part) =>
      ranges.some(
        (range) =>
          part.x >= range.x.min &&
          part.x <= range.x.max &&
          part.m >= range.m.min &&
          part.m <= range.m.max &&
          part.a >= range.a.min &&
          part.a <= range.a.max &&
          part.s >= range.s.min &&
          part.s <= range.s.max
      )
    )
    .reduce((a, b) => a + b.x + b.m + b.a + b.s, 0)
);

let totalSize = 0;

for (const range of ranges) {
  totalSize += range.size();
}

console.log("Result 2:", totalSize);
