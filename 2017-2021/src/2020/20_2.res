open Tools

AoC.getInput("2020", "2", input_ => {
  let input =
    input_
    ->lines
    ->map(line =>
      switch line->match_re(%re("/([0-9]+)-([0-9]+)\s([a-z]):\s([a-z]+)/")) {
      | Some([_, min, max, letter, pass]) => (
          min->string_to_int->unsafe,
          max->string_to_int->unsafe,
          letter,
          pass,
        )
      | _ => failwith("Bad line: " ++ line)
      }
    )

  // part 1
  input
  ->count(((min, max, letter, pass)) =>
    pass->split("")->count(x => x == letter)->(l => l >= min && l <= max)
  )
  ->Js.log2("part 1:", _)

  input
  ->count(((i1, i2, letter, pass)) =>
    (pass->str_at(i1 - 1) == letter) != (pass->str_at(i2 - 1) == letter)
  )
  ->Js.log2("part 2:", _)
})
