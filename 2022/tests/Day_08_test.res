open Jest

let input = `
30373
25512
65332
33549
35390
`

test("Part 1", () => {
  expect(Day_08.part1(input->trimEmptyLines))->toBe(21)
})

test("Part 2", () => {
  expect(Day_08.part2(input->trimEmptyLines))->toBe(8)
})

// Js.log(Day_08.part1(Input_08.input->trimEmptyLines))
// Js.log(Day_08.part2(Input_08.input->trimEmptyLines))
