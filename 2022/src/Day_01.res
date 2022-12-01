type acc = {current: int, largest: int}

let part1 = input => {
  let lines = input->Js.String2.trim->Js.String2.split("\n")

  let result = lines->Js.Array2.reduce(({current, largest}, line) => {
    let trimmed = line->Js.String2.trim

    switch trimmed {
    | "" if current > largest => {current: 0, largest: current}
    | "" => {current: 0, largest}
    | num => {current: current + num->Js.Float.fromString->Belt.Float.toInt, largest}
    }
  }, {current: 0, largest: 0})

  result.largest
}

let part2 = input => {
  let groups = input->Js.String2.trim->Js.String2.split("\n\n")

  groups
  ->Js.Array2.map(group =>
    group
    ->Js.String2.split("\n")
    ->Js.Array2.map(Js.Float.fromString)
    ->Js.Array2.reduce((a, n) => a +. n, 0.0)
  )
  ->Js.Array2.sortInPlaceWith((a, b) => (b -. a)->Belt.Float.toInt)
  ->Js.Array2.slice(~start=0, ~end_=3)
  ->Js.Array2.reduce((a, n) => a +. n, 0.0)
  ->Belt.Float.toInt
}
