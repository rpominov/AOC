open Tools

let draw = img => img->map(row => row->map(x => x == "1" ? "#" : ".")->join(""))->join("\n")

let enhance = ((img, fill), algo) => {
  let maxY = img->length + 1
  let maxX = img->unsafe_at(0)->length + 1
  let filledRow = Belt.Array.make(maxY + 3, fill)

  let img' =
    [
      [filledRow, filledRow],
      img->map(row => [[fill, fill], row, [fill, fill]]->flat),
      [filledRow, filledRow],
    ]->flat

  let fill' =
    algo->unsafe_at(
      [filledRow, filledRow, filledRow]->flat->join("")->string_to_int_radix(2)->unsafe,
    )

  (
    range(0, maxY)->map(y =>
      range(0, maxX)->map(x => {
        let subImg = img'->slice(y, y + 3)->map(slice(_, x, x + 3))
        let keyB = subImg->flat->join("")
        let key = keyB->string_to_int_radix(2)->unsafe
        let result = algo->unsafe_at(key)

        // j`($x, $y)\n${subImg->draw} -> $keyB -> $key -> ${result == "1" ? "#" : "."}\n`->Js.log

        result
      })
    ),
    fill',
  )
}

AoC.getInput("2021", "20", input_ => {
  let input = input_->split("\n\n")
  let algo =
    input[0]
    ->exn
    ->split("")
    ->filterMap(x =>
      switch x {
      | "#" => Some("1")
      | "." => Some("0")
      | _ => None
      }
    )
  let inputImg = input[1]->exn->lines->map(line => line->split("")->map(x => x == "#" ? "1" : "0"))

  // part 1
  let (enhanced, _) = (inputImg, "0")->enhance(algo)->enhance(algo)
  enhanced->flat->filter(x => x == "1")->length->Js.log

  // part 2
  let (enhanced, _) = range(1, 50)->reduce((inputImg, "0"), (acc, _) => acc->enhance(algo))
  enhanced->flat->filter(x => x == "1")->length->Js.log
})
