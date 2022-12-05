open Jest

let input = ``

test("Part 1", () => {
  expect(Day_07.part1(input->trimEmptyLines))->toBe(0)
})

test("Part 2", () => {
  expect(Day_07.part2(input->trimEmptyLines))->toBe(0)
})

// Js.log(Day_07.part1(Input_07.input->trimEmptyLines))
// Js.log(Day_07.part2(Input_07.input->trimEmptyLines))
