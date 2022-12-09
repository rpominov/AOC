open Jest

let input = `
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
`

test("Part 1", () => {
  expect(Day_07.part1(input->trimEmptyLines))->toBe(95437.)
})

test("Part 2", () => {
  expect(Day_07.part2(input->trimEmptyLines))->toBe(24933642.)
})

// Js.log(Day_07.part1(Input_07.input->trimEmptyLines))
// Js.log(Day_07.part2(Input_07.input->trimEmptyLines))
