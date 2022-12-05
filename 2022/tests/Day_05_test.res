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

let trimEmptyLines = str => {
  let arr = str->Js.String2.split("\n")
  let arr2 =
    arr
    ->Js.Array2.sliceFrom(arr->Js.Array2.findIndex(x => x->Js.String2.trim !== ""))
    ->Js.Array2.reverseInPlace
  arr2
  ->Js.Array2.sliceFrom(arr2->Js.Array2.findIndex(x => x->Js.String2.trim !== ""))
  ->Js.Array2.reverseInPlace
  ->Js.Array2.joinWith("\n")
}

test("Part 1", () => {
  expect(Day_05.part1(input->trimEmptyLines))->toBe("CMZ")
})

test("Part 2", () => {
  expect(Day_05.part2(input->trimEmptyLines))->toBe(0)
})

// Js.log(Day_05.part1(Input_05.input->trimEmptyLines))
// Js.log(Day_05.part2(Input_05.input->trimEmptyLines))
