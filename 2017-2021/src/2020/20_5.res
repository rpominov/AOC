open Tools
module Option = Belt.Option

let parseBinary = str =>
  str
  ->split("")
  ->map(x => x == "F" || x == "L" ? "0" : "1")
  ->join("")
  ->string_to_int_radix(2)
  ->unsafe

AoC.getInput("2020", "5", input => {
  let ids =
    input
    ->lines
    ->map(line =>
      line->string_slice(0, 7)->parseBinary * 8 + line->string_slice(7, 10)->parseBinary
    )

  // part 1
  ids->maxMany->Js.log

  // part 2
  ids
  ->Belt.SortArray.Int.stableSort
  ->findi((x, i, arr) => Some(x + 2) == arr[i + 1])
  ->Option.map(x => x + 1)
  ->Js.log
})
