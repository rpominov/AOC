open Jest

let input = `
A Y
B X
C Z
`

test("Part 1", () => {
  expect(Day_02.part1(input))->toBe(15)
})

test("Part 2", () => {
  expect(Day_02.part2(input))->toBe(12)
})

// Js.log(Day_02.part1(Input_02.input))
// Js.log(Day_02.part2(Input_02.input))
