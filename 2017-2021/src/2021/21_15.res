open Tools
module Map = Belt.HashMap

let findPath = riskMap => {
  let end = Point.make(riskMap[0]->exn->length - 1, riskMap->length - 1)
  let start = Point.make(0, 0)
  let getRisk = point => riskMap->Point.arrAt(point)->exn

  let known = Map.make(~hintSize=(end.x + 1) * (end.y + 1), ~id=module(Point.Hashable))

  known->Map.set(end, getRisk(end))
  let updatedAtPrevStep = ref([end])

  while updatedAtPrevStep.contents->length > 0 {
    updatedAtPrevStep :=
      updatedAtPrevStep.contents
      ->map(updated =>
        [(-1, 0), (1, 0), (0, -1), (0, 1)]->filterMap(direction => {
          let point = updated->Point.shiftBy(direction)
          if Point.inRange(point, start, end) {
            let new = known->Map.get(updated)->unsafe + point->getRisk
            switch known->Map.get(point) {
            | Some(x) if x <= new => None
            | _ => {
                known->Map.set(point, new)
                Some(point)
              }
            }
          } else {
            None
          }
        })
      )
      ->flat
  }

  known->Map.get(start)->exn - getRisk(start)
}

let replicate = orig => {
  Tools.range(0, 4)
  ->map(b =>
    orig->map(line =>
      Tools.range(0, 4)->map(a => line->map(v => v + a + b))->flat->map(v => v > 9 ? v - 9 : v)
    )
  )
  ->flat
}

AoC.getInput("2021", "15", input_ => {
  let input = input_->lines->map(line => line->split("")->map(string_to_int_unsafe))

  // part 1
  input->findPath->Js.log

  // part 2
  input->replicate->findPath->Js.log
})
