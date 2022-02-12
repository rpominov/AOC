open Tools
module Set = StringSet
module Map = Belt.MutableMap.String

AoC.getInput("2017", "24", input => {
  let components =
    input->lines->map(line => line->split("/")->map(string_to_int_unsafe)->array_to_pair->exn)

  let findBridge = sortBy => {
    let memo = Map.make()
    let rec helper = (usedIndices, firstPort) => {
      let key = usedIndices->Set.toString ++ firstPort->int_to_string
      switch memo->Map.get(key) {
      | Some(result) => result
      | None => {
          let options = components->flatMapi(((p1, p2), i, _) => {
            if usedIndices->Set.has(i) {
              []
            } else if p1 === firstPort {
              let (l, s) = helper(usedIndices->Set.add(i), p2)
              [(l + 1, s + p1 + p2)]
            } else if p2 === firstPort {
              let (l, s) = helper(usedIndices->Set.add(i), p1)
              [(l + 1, s + p1 + p2)]
            } else {
              []
            }
          })
          let result = options->length > 0 ? options->sortInPlace(sortBy)->unsafe_at(0) : (0, 0)
          memo->Map.set(key, result)
          result
        }
      }
    }
    helper(Set.empty, 0)->snd
  }

  findBridge((a, b) => b->snd - a->snd)->Js.log2("part 1:", _)

  findBridge((a, b) =>
    switch b->fst - a->fst {
    | 0 => b->snd - a->snd
    | x => x
    }
  )->Js.log2("part 2:", _)
})
