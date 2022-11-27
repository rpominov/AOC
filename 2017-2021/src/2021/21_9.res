open Tools
module Option = Belt.Option
module Set = Belt.Set.String

let atCoord = (arr, x, y) => arr[y]->Option.flatMap(row => row[x])->Option.getWithDefault(9)

AoC.getInput("2021", "9", input_ => {
  let input = input_->lines->map(line => line->split("")->map(string_to_int_unsafe))

  let isLow = (v, x, y) => {
    v < input->atCoord(x - 1, y) &&
    v < input->atCoord(x + 1, y) &&
    v < input->atCoord(x, y - 1) &&
    v < input->atCoord(x, y + 1)
  }

  // part 1
  input
  ->mapi((row, y, _) => row->mapi((el, x, _) => isLow(el, x, y) ? el + 1 : 0))
  ->flat
  ->reduce(0, \"+")
  ->Js.log

  // part 2

  let rec helper = (acc, el, x, y) => {
    switch input->atCoord(x, y) {
    | 9 => acc
    | v if v <= el => acc
    | v => acc->basin(v, x, y)
    }
  }
  and basin = (acc, el, x, y) => {
    acc
    ->Set.add(int_to_string(x) ++ "," ++ int_to_string(y))
    ->helper(el, x - 1, y)
    ->helper(el, x + 1, y)
    ->helper(el, x, y - 1)
    ->helper(el, x, y + 1)
  }

  input
  ->mapi((row, y, _) => {
    row->mapi((el, x, _) => isLow(el, x, y) ? Set.empty->basin(el, x, y)->Set.size : 0)
  })
  ->flat
  ->sort((a, b) => b - a)
  ->slice(0, 3)
  ->reduce(1, \"*")
  ->Js.log
})
