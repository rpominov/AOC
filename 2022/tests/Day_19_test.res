open Jest

let input = ``

test("Part 1", () => {
  expect(Day_19.part1(input->trimEmptyLines))->toBe(0)
})

test("Part 2", () => {
  expect(Day_19.part2(input->trimEmptyLines))->toBe(0)
})

// Js.log(Day_19.part1(Input_19.input->trimEmptyLines))
// Js.log(Day_19.part2(Input_19.input->trimEmptyLines))
