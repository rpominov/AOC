module S = Js.String2
module A = Js.Array2

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
  | [stacksText, _procedureText] => {
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

      stacks
    }

  | _ => failwith("Invalid input")
  }
}

let part1 = _input => {
  ""
}

let part2 = _input => {
  0
}
