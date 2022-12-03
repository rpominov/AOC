open Jest

let input = `
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
`

test("Part 1", () => {
  expect(Day_03.part1(input))->toBe(157)
})

test("Part 2", () => {
  expect(Day_03.part2(input))->toBe(70)
})

// Js.log(Day_03.part1(Input_03.input))
// Js.log(Day_03.part2(Input_03.input))
