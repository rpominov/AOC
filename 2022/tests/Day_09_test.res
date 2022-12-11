open Jest

let input = `
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
`

let input2 = `
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
`

test("Part 1", () => {
  expect(Day_09.part1(input->trimEmptyLines))->toBe(13)
})

test("Part 2", () => {
  expect(Day_09.part2(input->trimEmptyLines))->toBe(1)
  expect(Day_09.part2(input2->trimEmptyLines))->toBe(36)
})

// Js.log(Day_09.part1(Input_09.input->trimEmptyLines))
// Js.log(Day_09.part2(Input_09.input->trimEmptyLines))
