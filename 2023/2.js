const input = `Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green`;

const parsed = input.split("\n").map((line) => {
  const [game, rounds] = line.split(": ");
  return {
    game: Number(game.replace("Game ", "")),
    rounds: rounds
      .split("; ")
      .map((round) => round.split(", ").map((x) => x.split(" "))),
  };
});

// only 12 red cubes, 13 green cubes, and 14 blue
const limit = { red: 12, green: 13, blue: 14 };

const result1 = parsed
  .filter(({ rounds }) =>
    rounds.flat().every(([count, color]) => count <= limit[color])
  )
  .reduce((acc, { game }) => acc + game, 0);

console.log("Result 1:", result1);

const result2 = parsed
  .map(({ rounds }) => {
    const min = { red: 0, green: 0, blue: 0 };
    rounds.flat().forEach(([count, color]) => {
      min[color] = Math.max(min[color], count);
    });
    return min.red * min.green * min.blue;
  })
  .reduce((a, b) => a + b, 0);

console.log("Result 2:", result2);
