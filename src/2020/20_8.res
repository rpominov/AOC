open Tools
module Set = Belt.Set

type instruction = Acc(int) | Jmp(int) | Nop(int)
type runResult = Loop(int, int) | OutOfRange(int, int)

let resultToString = result =>
  switch result {
  | Loop(pos, value) => "Loop at " ++ pos->int_to_string ++ ". Value = " ++ value->int_to_string
  | OutOfRange(pos, value) =>
    "Out of range at " ++ pos->int_to_string ++ ". Value = " ++ value->int_to_string
  }

let run = instructions => {
  let visited = ref(Set.Int.empty)
  let next = ref(0)
  let value = ref(0)

  while (
    visited.contents->Set.Int.has(next.contents)->not &&
    next.contents >= 0 &&
    next.contents < instructions->length
  ) {
    visited := visited.contents->Set.Int.add(next.contents)
    switch instructions[next.contents]->exn {
    | Nop(_) => next := next.contents + 1
    | Acc(x) => {
        value := value.contents + x
        next := next.contents + 1
      }
    | Jmp(x) => next := next.contents + x
    }
  }

  visited.contents->Set.Int.has(next.contents)
    ? Loop(next.contents, value.contents)
    : OutOfRange(next.contents, value.contents)
}

AoC.getInput("2020", "8", input_ => {
  let input =
    input_
    ->lines
    ->map(line =>
      switch line->split(" ") {
      | [a, b] =>
        switch a {
        | "acc" => Acc(b->string_to_int_unsafe)
        | "jmp" => Jmp(b->string_to_int_unsafe)
        | "nop" => Nop(b->string_to_int_unsafe)
        | _ => failwith("bad line: " ++ line)
        }
      | _ => failwith("bad line: " ++ line)
      }
    )

  // part 1
  input->run->resultToString->Js.log

  // part 2
  input
  ->Js.Array2.somei((x, i) => {
    switch switch x {
    | Acc(_) => None
    | Nop(y) => Some(input->mapi((z, j, _) => i == j ? Jmp(y) : z))
    | Jmp(y) => Some(input->mapi((z, j, _) => i == j ? Nop(y) : z))
    } {
    | None => false
    | Some(modInstructions) =>
      switch modInstructions->run {
      | OutOfRange(pos, value) if pos == modInstructions->length => {
          value->Js.log
          true
        }
      | _ => false
      }
    }
  })
  ->ignore
})
