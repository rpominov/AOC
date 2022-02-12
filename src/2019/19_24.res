open Tools
module Set = Belt.MutableSet.Int

let width = 5
let height = 5

let adjacentSum = (arr, i) => {
  let m = i->mod(width)
  (m === 0 ? 0 : arr->unsafe_at(i - 1)) +
  (i < width ? 0 : arr->unsafe_at(i - width)) +
  (m === width - 1 ? 0 : arr->unsafe_at(i + 1)) + (
    i >= width * (height - 1) ? 0 : arr->unsafe_at(i + width)
  )
}

let step = mapi(_, (v, i, arr) =>
  switch arr->adjacentSum(i) {
  | 1 => 1
  | 2 if v === 0 => 1
  | _ => 0
  }
)

let rating = arr =>
  arr->Js.Array2.reverseInPlace->map(int_to_string)->join("")->string_to_int_radix(2)->unsafe

AoC.getInput("2019", "24", input => {
  let initialState =
    input
    ->lines
    ->flatMap(line =>
      line
      ->split("")
      ->map(x =>
        switch x {
        | "#" => 1
        | "." => 0
        | _ => failwith(x)
        }
      )
    )

  let seenStates = Set.make()

  let rec findRepeat = state => {
    let r = state->rating
    if seenStates->Set.has(r) {
      r
    } else {
      seenStates->Set.add(r)
      findRepeat(state->step)
    }
  }

  initialState->findRepeat->Js.log2("part 1:", _)
})
