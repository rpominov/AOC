const input = `32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483`;

const getStrength = (hand, cardsOrder = "AKQJT98765432") => {
  const cards = {};
  const strength = [];
  for (let i = 0; i < hand.length; i++) {
    const c = hand[i];
    cards[c] = (cards[c] || 0) + 1;
    strength.push(cardsOrder.indexOf(c));
  }
  const v = Object.values(cards);
  const type = v.includes(5)
    ? 0
    : v.includes(4)
    ? 1
    : v.includes(3) && v.includes(2)
    ? 2
    : v.includes(3)
    ? 3
    : v.filter((x) => x === 2).length === 2
    ? 4
    : v.includes(2)
    ? 5
    : 6;
  return [type, ...strength];
};

const parsed = input.split("\n").map((line) => {
  const [hand, points] = line.split(" ");
  return {
    hand,
    points: Number(points),
    strength: getStrength(hand),
  };
});

const cmp = (a, b) => {
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) {
      return b[i] - a[i];
    }
  }
  return 0;
};

parsed.sort((a, b) => cmp(a.strength, b.strength));

console.log(
  "Result 1:",
  parsed.map(({ points }, i) => points * (i + 1)).reduce((a, b) => a + b, 0)
);

const getBestVariant = (card) => {
  if (card.indexOf("J") === -1) {
    return card;
  }

  const variants = [
    ..."AKQT98765432".split("").map((x) => card.replace("J", x)),
  ].map((x) => [x, getStrength(x)]);

  return getBestVariant(variants.sort((a, b) => cmp(a[1], b[1])).at(-1)[0]);
};

const hands2 = parsed
  .map(({ hand, points }) => {
    const type = getStrength(getBestVariant(hand))[0];
    const [, ...rest] = getStrength(hand, "AKQT98765432J");
    return { points, strength: [type, ...rest] };
  })
  .sort((a, b) => cmp(a.strength, b.strength));

console.log(
  "Result 2:",
  hands2.map(({ points }, i) => points * (i + 1)).reduce((a, b) => a + b, 0)
);
