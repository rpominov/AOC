open Jest

let input = ``

test("Part 1", () => {
  expect(Day_17.part1(input->trimEmptyLines))->toBe(0)
})

test("Part 2", () => {
  expect(Day_17.part2(input->trimEmptyLines))->toBe(0)
})

// Js.log(Day_17.part1(Input_17.input->trimEmptyLines))
// Js.log(Day_17.part2(Input_17.input->trimEmptyLines))
