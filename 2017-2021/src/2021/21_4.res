open Tools

let rotate = arr2d => {
  arr2d[0]->exn->mapi((_, i, _) => arr2d->map(x => x[i]->unsafe))
}

let isWinner = (board, seq) => {
  board->concat(board->rotate)->some(every(_, seq->includes))
}

let getScore = (board, seq) => {
  let unmarked = board->flat->filter(x => seq->includes(x)->not)
  unmarked->reduce(0, \"+") * seq->last->unsafe
}

AoC.getInput("2021", "4", input_ => {
  let input = input_->split("\n\n")->map(trim)

  let seq = input[0]->exn->split(",")->map(string_to_int_unsafe)
  let subSeq = l => seq->Belt.Array.slice(~offset=0, ~len=l)

  let boards =
    input
    ->sliceFrom(1)
    ->map(str => str->lines->map(s => s->trim->splitr(%re("/\s+/"))->map(string_to_int_unsafe)))

  let rec getFirstWinnerScore = pos => {
    let seq = subSeq(pos)
    switch boards->find(isWinner(_, seq)) {
    | Some(board) => board->getScore(seq)
    | None => getFirstWinnerScore(pos + 1)
    }
  }

  Js.log(`First winner score: ${getFirstWinnerScore(1)->int_to_string}`)

  let rec getLastWinnerScore = pos => {
    let seq = subSeq(pos)
    switch boards->find(board => board->isWinner(seq)->not) {
    | Some(board) => board->getScore(subSeq(pos + 1))
    | None => getLastWinnerScore(pos - 1)
    }
  }

  Js.log(`Last winner score: ${getLastWinnerScore(seq->length)->int_to_string}`)
})
