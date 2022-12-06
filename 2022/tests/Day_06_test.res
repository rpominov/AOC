open Jest

let input1 = `mjqjpqmgbljsphdztnvjfqwrcgsmlb`
let input2 = `bvwbjplbgvbhsrlpgdmjqwftvncz`
let input3 = `nppdvjthqldpwncqszvftbrmjlhg`
let input4 = `nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg`
let input5 = `zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw`

test("Part 1", () => {
  expect(Day_06.part1(input1->trimEmptyLines))->toBe(7)
  expect(Day_06.part1(input2->trimEmptyLines))->toBe(5)
  expect(Day_06.part1(input3->trimEmptyLines))->toBe(6)
  expect(Day_06.part1(input4->trimEmptyLines))->toBe(10)
  expect(Day_06.part1(input5->trimEmptyLines))->toBe(11)
})

test("Part 2", () => {
  expect(Day_06.part2(input1->trimEmptyLines))->toBe(19)
  expect(Day_06.part2(input2->trimEmptyLines))->toBe(23)
  expect(Day_06.part2(input3->trimEmptyLines))->toBe(23)
  expect(Day_06.part2(input4->trimEmptyLines))->toBe(29)
  expect(Day_06.part2(input5->trimEmptyLines))->toBe(26)
})

// Js.log(Day_06.part1(Input_06.input->trimEmptyLines))
// Js.log(Day_06.part2(Input_06.input->trimEmptyLines))
