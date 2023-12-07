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

const getType = (hand) => getStrength(hand)[0];

const sort = (hands) =>
  hands.sort(({ strength: a }, { strength: b }) => {
    for (let i = 0; i < a.length; i++) {
      if (a[i] !== b[i]) {
        return b[i] - a[i];
      }
    }
    return 0;
  });

const parsed = input.split("\n").map((line) => {
  const [hand, points] = line.split(" ");
  return { hand, points: Number(points), strength: getStrength(hand) };
});

sort(parsed);

console.log(
  "Result 1:",
  parsed.map(({ points }, i) => points * (i + 1)).reduce((a, b) => a + b, 0)
);

const getBestVariant = (hand) => {
  if (hand.indexOf("J") === -1) {
    return hand;
  }

  return getBestVariant(
    hand
      .split("")
      .filter((c) => c !== "J")
      .map((c) => hand.replace("J", c))
      .map((v) => [v, getType(v)])
      .sort(([, a], [, b]) => b - a)[0][0]
  );
};

const hands2 = parsed.map(({ hand, points }) => {
  const type = getType(getBestVariant(hand));
  const [, ...rest] = getStrength(hand, "AKQT98765432J");
  return { points, strength: [type, ...rest] };
});

sort(hands2);

console.log(
  "Result 2:",
  hands2.map(({ points }, i) => points * (i + 1)).reduce((a, b) => a + b, 0)
);
