open Jest

let input = `
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
`

test("Part 1", () => {
  expect(Day_05.part1(input->trimEmptyLines))->toBe("CMZ")
})

test("Part 2", () => {
  expect(Day_05.part2(input->trimEmptyLines))->toBe("MCD")
})

// Js.log(Day_05.part1(Input_05.input->trimEmptyLines))
// Js.log(Day_05.part2(Input_05.input->trimEmptyLines))
