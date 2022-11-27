open Tools
module Set = Belt.Set.String

AoC.getInput("2020", "7", input_ => {
  let input =
    input_
    ->lines
    ->map(line =>
      switch line->split(" bags contain ") {
      | [a, b] => (
          a,
          switch b {
          | "no other bags." => []
          | x =>
            x
            ->split(", ")
            ->map(y =>
              switch match_re(y, %re("/^([0-9]+)\s(.+)\sbags?\.?$/")) {
              | Some([_, n, color]) => (n->string_to_int_unsafe, color)
              | _ => failwith("bad line: " ++ line ++ " => " ++ y)
              }
            )
          },
        )
      | _ => failwith("bad line: " ++ line)
      }
    )

  // part 1
  let findParents = color =>
    input->filterMap(((container, content)) =>
      if content->some(((_, c)) => c == color) {
        Some(container)
      } else {
        None
      }
    )
  let rec getCompositions = color => {
    let parents = findParents(color)
    parents
    ->map(parent =>
      [[parent, color]]->concat(parent->getCompositions->map(comp => comp->concat([color])))
    )
    ->flat
  }
  getCompositions("shiny gold")->flat->Set.fromArray->Set.size->(x => x - 1)->Js.log

  // part 2
  let rec countChildren = color =>
    input
    ->find(((c, _)) => c == color)
    ->exn
    ->snd
    ->map(((n, c)) => n + n * countChildren(c))
    ->reduce(0, \"+")
  countChildren("shiny gold")->Js.log
})
