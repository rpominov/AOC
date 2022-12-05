module S = Js.String2
module A = Js.Array2
module O = Belt.Option

let rec getCrates = (~pos=0, ~acc=[], input) => {
  let posInText = pos * 4 + 1
  if input->S.length < posInText {
    acc
  } else {
    let char = input->S.charAt(posInText)
    let crate = char === " " ? None : Some(char)
    getCrates(~pos=pos + 1, ~acc=A.concat(acc, [crate]), input)
  }
}

let parse = input => {
  switch input->S.split("\n\n") {
  | [stacksText, procedureText] => {
      let stacks = []

      stacksText
      ->S.split("\n")
      ->A.reverseInPlace
      ->A.sliceFrom(1)
      ->A.forEach(line => {
        line
        ->getCrates
        ->A.forEachi((crate, i) => {
          switch crate {
          | Some(x) => {
              if stacks->A.length < i + 1 {
                stacks->A.push([])->ignore
              }
              stacks[i]->A.push(x)->ignore
            }

          | None => ()
          }
        })
      })

      let procedures =
        procedureText
        ->S.split("\n")
        ->A.map(line => {
          switch line->S.split(" ") {
          // move 1 from 8 to 4
          | [_move, n, _from, from, _to, to] => (
              n->int_of_string,
              from->int_of_string,
              to->int_of_string,
            )
          | _ => failwith("Invalid procedure: " ++ line)
          }
        })

      (stacks, procedures)
    }

  | _ => failwith("Invalid input")
  }
}

let part1 = input => {
  let (stacks, procedures) = parse(input)

  procedures->A.forEach(((n, from, to)) => {
    for _i in 0 to n - 1 {
      let crate = stacks[from - 1]->A.pop->O.getExn
      stacks[to - 1]->A.push(crate)->ignore
    }
  })

  stacks->A.map(stack => stack->A.pop)->A.joinWith("")
}

let part2 = input => {
  let (stacks, procedures) = parse(input)

  procedures->A.forEach(((n, from, to)) => {
    let tmp = []
    for _i in 0 to n - 1 {
      let crate = stacks[from - 1]->A.pop->O.getExn
      tmp->A.push(crate)->ignore
    }
    stacks[to - 1]->A.pushMany(tmp->A.reverseInPlace)->ignore
  })

  stacks->A.map(stack => stack->A.pop)->A.joinWith("")
}
