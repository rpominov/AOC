module S = Js.String2
module A = Js.Array2

let priority = "abcdefghijklmnopqrstuvwxyz" ++ "abcdefghijklmnopqrstuvwxyz"->Js.String2.toUpperCase

let part1 = input => {
  let rucksacks =
    input
    ->S.trim
    ->S.split("\n")
    ->A.map(line => {
      let length = line->S.length
      (
        line->S.slice(~from=0, ~to_=length / 2)->S.split("")->Belt.Set.String.fromArray,
        line->S.sliceToEnd(~from=length / 2)->S.split("")->Belt.Set.String.fromArray,
      )
    })

  let errorItems = rucksacks->A.map(((a, b)) =>
    switch Belt.Set.String.intersect(a, b)->Belt.Set.String.toArray {
    | [x] => x
    | _ => failwith("invalid input")
    }
  )

  errorItems->A.reduce((acc, x) => acc + priority->S.indexOf(x) + 1, 0)
}

let splitBy3 = array => {
  let length = array->A.length
  let result = []
  for i in 0 to length / 3 - 1 {
    result->A.push([array[i * 3], array[i * 3 + 1], array[i * 3 + 2]])->ignore
  }
  result
}

let allIntersect = array => {
  array
  ->A.reduce(
    (acc, x) => Belt.Set.String.intersect(acc, x->S.split("")->Belt.Set.String.fromArray),
    array[0]->S.split("")->Belt.Set.String.fromArray,
  )
  ->Belt.Set.String.toArray
  ->A.joinWith("")
}

let part2 = input => {
  let rucksacks = input->S.trim->S.split("\n")

  let badges = rucksacks->splitBy3->A.map(allIntersect)

  badges->A.reduce((acc, x) => acc + priority->S.indexOf(x) + 1, 0)
}
