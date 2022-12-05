open Jest

let input = `
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
`

test("Part 1", () => {
  expect(Day_01.part1(input->trimEmptyLines))->toBe(24000)
})

test("Part 2", () => {
  expect(Day_01.part2(input->trimEmptyLines))->toBe(45000)
})

// Js.log(Day_01.part1(Input_01.input->trimEmptyLines))
// Js.log(Day_01.part2(Input_01.input->trimEmptyLines))
