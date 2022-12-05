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
  expect(Day_03.part1(input->trimEmptyLines))->toBe(157)
})

test("Part 2", () => {
  expect(Day_03.part2(input->trimEmptyLines))->toBe(70)
})

// Js.log(Day_03.part1(Input_03.input->trimEmptyLines))
// Js.log(Day_03.part2(Input_03.input->trimEmptyLines))
