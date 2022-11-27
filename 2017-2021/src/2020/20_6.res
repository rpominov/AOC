open Tools
module Set = Belt.Set.String

AoC.getInput("2020", "6", input_ => {
  let input = input_->split("\n\n")->map(lines)

  input->mapSum(lines => lines->join("")->split("")->Set.fromArray->Set.size)->Js.log2("part 1:", _)

  input
  ->mapSum(lines => lines->unsafe_at(0)->split("")->count(x => lines->every(string_includes(_, x))))
  ->Js.log2("part 2:", _)
})
