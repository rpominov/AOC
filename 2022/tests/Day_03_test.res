open Jest

let input = ``

test("Part 1", () => {
  expect(Day_03.part1(input))->toBe(0)
})

test("Part 2", () => {
  expect(Day_03.part2(input))->toBe(0)
})

Js.log(Day_03.part1(Input_03.input))
Js.log(Day_03.part2(Input_03.input))
