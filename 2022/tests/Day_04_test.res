open Jest

let input = `
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
`

test("Part 1", () => {
  expect(Day_04.part1(input->trimEmptyLines))->toBe(2)
})

test("Part 2", () => {
  expect(Day_04.part2(input->trimEmptyLines))->toBe(4)
})

// Js.log(Day_04.part1(Input_04.input->trimEmptyLines))
// Js.log(Day_04.part2(Input_04.input->trimEmptyLines))
