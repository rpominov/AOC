open Jest

let input = ``

test("Part 1", () => {
  expect(Day_25.part1(input->trimEmptyLines))->toBe(0)
})

test("Part 2", () => {
  expect(Day_25.part2(input->trimEmptyLines))->toBe(0)
})

// Js.log(Day_25.part1(Input_25.input->trimEmptyLines))
// Js.log(Day_25.part2(Input_25.input->trimEmptyLines))
