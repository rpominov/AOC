open Tools

AoC.getInput("2020", "1", input_ => {
  let input = input_->lines->filterMap(string_to_int)

  input->find(x => input->includes(2020 - x))->exn->(x => x * (2020 - x))->Js.log2("part 1:", _)

  input
  ->findMap(x =>
    input->findMap(y => input->includes(2020 - x - y) ? Some(x * y * (2020 - x - y)) : None)
  )
  ->exn
  ->Js.log2("part 2:", _)
})
