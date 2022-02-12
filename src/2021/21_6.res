open Tools

let modAt = (arr, i, f) => arr->mapi((y, _i, _) => i == _i ? f(y) : y)

let prog = groups => {
  let zeros = groups[0]->exn
  groups->sliceFrom(1)->concat([zeros])->modAt(6, Int64.add(zeros))
}

AoC.getInput("2021", "6", input_ => {
  let groups =
    input_
    ->split(",")
    ->map(string_to_int_unsafe)
    ->reduce([0, 0, 0, 0, 0, 0, 0, 0, 0]->map(Int64.of_int), (acc, x) =>
      acc->modAt(x, Int64.add(Int64.one))
    )

  Js.log(
    range(1, 256)
    ->reduce(groups, (acc, _) => acc->prog)
    ->reduce(Int64.zero, Int64.add)
    ->Int64.to_string,
  )
})
