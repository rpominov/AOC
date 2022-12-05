open Jest

let input = `
A Y
B X
C Z
`

test("Part 1", () => {
  expect(Day_02.part1(input->trimEmptyLines))->toBe(15)
})

test("Part 2", () => {
  expect(Day_02.part2(input->trimEmptyLines))->toBe(12)
})

// Js.log(Day_02.part1(Input_02.input->trimEmptyLines))
// Js.log(Day_02.part2(Input_02.input->trimEmptyLines))
