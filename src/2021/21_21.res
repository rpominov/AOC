open Tools
module List = Belt.List

let wr = (v, at) =>
  switch mod(v, at) {
  | 0 => at
  | x => x
  }

let getWinner = (winScore, p1pos, p2pos, p1score, p2score, turn, rollsSum) =>
  switch turn {
  | #1 => {
      let p1pos' = wr(p1pos + rollsSum, 10)
      let p1score' = p1score + p1pos'
      p1score' >= winScore ? Ok(#1) : Error((p1pos', p2pos, p1score', p2score, #2))
    }
  | #2 => {
      let p2pos' = wr(p2pos + rollsSum, 10)
      let p2score' = p2score + p2pos'
      p2score' >= winScore ? Ok(#2) : Error((p1pos, p2pos', p1score, p2score', #1))
    }
  }

AoC.getInput("2021", "21", input_ => {
  let input = input_->lines->map(line => (line->split(": "))[1]->exn->string_to_int_unsafe)
  let p1start = input[0]->exn
  let p2start = input[1]->exn

  // part 1

  let rec play = (p1pos, p2pos, p1score, p2score, turn, roll) => {
    switch getWinner(
      1000,
      p1pos,
      p2pos,
      p1score,
      p2score,
      turn,
      wr(roll, 100) + wr(roll + 1, 100) + wr(roll + 2, 100),
    ) {
    | Ok(#1) => p2score * (roll + 2)
    | Ok(#2) => p1score * (roll + 2)
    | Error((p1pos', p2pos', p1score', p2score', turn')) =>
      play(p1pos', p2pos', p1score', p2score', turn', roll + 3)
    }
  }

  play(p1start, p2start, 0, 0, #1, 1)->Js.log

  // part 2

  let splits = list{(3, 1.), (4, 3.), (5, 6.), (6, 7.), (7, 6.), (8, 3.), (9, 1.)}

  let rec count = (p1wins, p2wins, jobs) => {
    switch jobs {
    | list{} => Js.Math.max_float(p1wins, p2wins)
    | list{(p1pos, p2pos, p1score, p2score, turn, rollsSum, uniCount), ...jobs'} =>
      switch getWinner(21, p1pos, p2pos, p1score, p2score, turn, rollsSum) {
      | Ok(#1) => count(p1wins +. uniCount, p2wins, jobs')
      | Ok(#2) => count(p1wins, p2wins +. uniCount, jobs')
      | Error((p1pos', p2pos', p1score', p2score', turn')) =>
        count(
          p1wins,
          p2wins,
          splits
          ->List.map(((rollsSum, uniCount')) => (
            p1pos',
            p2pos',
            p1score',
            p2score',
            turn',
            rollsSum,
            uniCount' *. uniCount,
          ))
          ->List.concat(jobs'),
        )
      }
    }
  }

  count(
    0.,
    0.,
    splits->List.map(((rollsSum, uniCount)) => (p1start, p2start, 0, 0, #1, rollsSum, uniCount)),
  )->Js.log
})
