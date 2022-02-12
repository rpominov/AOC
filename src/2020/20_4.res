open Tools

AoC.getInput("2020", "4", input_ => {
  let passports =
    input_
    ->split("\n\n")
    ->map(str => {
      str
      ->splitr(%re("/\s/"))
      ->filter(x => x != "")
      ->map(pair =>
        switch pair->split(":") {
        | [key, val] => (key, val)
        | _ => failwith("Bad pair: " ++ pair)
        }
      )
    })

  let required = [
    (
      "byr",
      s =>
        switch s->string_to_int {
        | Some(v) => v >= 1920 && v <= 2002
        | _ => false
        },
    ),
    (
      "iyr",
      s =>
        switch s->string_to_int {
        | Some(v) => v >= 2010 && v <= 2020
        | _ => false
        },
    ),
    (
      "eyr",
      s =>
        switch s->string_to_int {
        | Some(v) => v >= 2020 && v <= 2030
        | _ => false
        },
    ),
    (
      "hgt",
      s =>
        switch s->match_re(%re("/^([0-9]+)(cm|in)$/")) {
        | Some([_, n, "cm"]) => n->string_to_int->unsafe >= 150 && n->string_to_int->unsafe <= 193
        | Some([_, n, "in"]) => n->string_to_int->unsafe >= 59 && n->string_to_int->unsafe <= 76
        | _ => false
        },
    ),
    ("hcl", s => %re("/^#[0-9a-f]{6}$/")->Js.Re.test_(s)),
    ("ecl", s => ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]->includes(s)),
    ("pid", s => %re("/^[0-9]{9}$/")->Js.Re.test_(s)),
  ]

  // part 1
  passports
  ->count(data => {
    let fields = data->map(((k, _)) => k)
    required->every(((k, _)) => fields->includes(k))
  })
  ->Js.log

  // part 2
  passports
  ->count(data => required->every(((k, f)) => data->some(((k1, v)) => k1 == k && f(v))))
  ->Js.log
})
