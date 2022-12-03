let priority = "abcdefghijklmnopqrstuvwxyz" ++ "abcdefghijklmnopqrstuvwxyz"->Js.String2.toUpperCase

let part1 = input => {
  let rucksacks =
    input
    ->Js.String2.trim
    ->Js.String2.split("\n")
    ->Js.Array2.map(line => {
      let length = line->Js.String2.length
      (
        line
        ->Js.String2.slice(~from=0, ~to_=length / 2)
        ->Js.String2.split("")
        ->Belt.Set.String.fromArray,
        line
        ->Js.String2.sliceToEnd(~from=length / 2)
        ->Js.String2.split("")
        ->Belt.Set.String.fromArray,
      )
    })

  let errorItems = rucksacks->Js.Array2.map(((a, b)) =>
    switch Belt.Set.String.intersect(a, b)->Belt.Set.String.toArray {
    | [x] => x
    | _ => failwith("invalid input")
    }
  )

  errorItems->Js.Array2.reduce((acc, x) => acc + priority->Js.String2.indexOf(x) + 1, 0)
}

let splitBy3 = array => {
  let length = array->Js.Array2.length
  let result = []
  for i in 0 to length / 3 - 1 {
    result->Js.Array2.push([array[i * 3], array[i * 3 + 1], array[i * 3 + 2]])->ignore
  }
  result
}

let allIntersect = array => {
  array
  ->Js.Array2.reduce(
    (acc, x) => Belt.Set.String.intersect(acc, x->Js.String2.split("")->Belt.Set.String.fromArray),
    array[0]->Js.String2.split("")->Belt.Set.String.fromArray,
  )
  ->Belt.Set.String.toArray
  ->Js.Array2.joinWith("")
}

let part2 = input => {
  let rucksacks = input->Js.String2.trim->Js.String2.split("\n")

  let badges = rucksacks->splitBy3->Js.Array2.map(allIntersect)

  badges->Js.Array2.reduce((acc, x) => acc + priority->Js.String2.indexOf(x) + 1, 0)
}
