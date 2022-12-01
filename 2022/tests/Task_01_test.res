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
  expect(Task_01.part1(input))->toBe(24000)
})

test("Part 2", () => {
  expect(Task_01.part2(input))->toBe(45000)
})
