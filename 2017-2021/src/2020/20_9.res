open Tools

AoC.getInput("2020", "9", input_ => {
  let input = input_->lines->filterMap(string_to_int)

  let invalid =
    input
    ->sliceFrom(25)
    ->findi((x, i, _) => {
      let prev = input->slice(i, i + 25)
      prev->some(y => prev->includes(x - y))->not
    })
    ->exn

  invalid->Js.log2("part 1:", _)

  let rec iterateLow = (sum, lowI, highI) => {
    if sum === invalid {
      let seq = input->slice(lowI, highI)
      Some(seq->minMany + seq->maxMany)
    } else if lowI === 0 {
      None
    } else {
      iterateLow(sum + input->unsafe_at(lowI - 1), lowI - 1, highI)
    }
  }

  range(1, input->length)->findMap(highI => iterateLow(0, highI, highI))->Js.log2("part 2:", _)
})
