open Tools
module Map = Belt.MutableMap.Int

AoC.getInput("2020", "10", input_ => {
  let input = input_->lines->filterMap(string_to_int)->sort((a, b) => a - b)

  let diffs = input->mapi((v, i, a) => i === 0 ? v : v - a->unsafe_at(i - 1))
  Js.log2("part 1:", (diffs->count(x => x === 3) + 1) * diffs->count(x => x === 1))

  let mem = Map.make()
  let rec ways = toGetTo =>
    toGetTo === 0
      ? 1.
      : input->includes(toGetTo)->not
      ? 0.
      : switch mem->Map.get(toGetTo) {
        | Some(result) => result
        | None => {
            let result = ways(toGetTo - 1) +. ways(toGetTo - 2) +. ways(toGetTo - 3)
            mem->Map.set(toGetTo, result)
            result
          }
        }

  Js.log2("part 2:", ways(input->last->unsafe))
})
