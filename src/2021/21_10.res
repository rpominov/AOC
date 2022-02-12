open Tools

let isOpen = symbol =>
  switch symbol {
  | "[" | "(" | "<" | "{" => true
  | _ => false
  }

let isPair = (cl, op) =>
  switch (cl, op) {
  | ("}", "{")
  | ("]", "[")
  | (")", "(")
  | (">", "<") => true
  | _ => false
  }

let getErrPoints = closeSymbol =>
  switch closeSymbol {
  | ")" => 3
  | "]" => 57
  | "}" => 1197
  | ">" => 25137
  | s => failwith(s)
  }

let getCompPoints = openSymbol =>
  switch openSymbol {
  | "(" => 1
  | "[" => 2
  | "{" => 3
  | "<" => 4
  | s => failwith(s)
  }

AoC.getInput("2021", "10", input => {
  let intermediate =
    input
    ->lines
    ->map(line => {
      line
      ->split(_, "")
      ->reduce(Ok(list{}), (acc, symbol) => {
        switch acc {
        | Ok(stack) if isOpen(symbol) => Ok(list{symbol, ...stack})
        | Ok(list{last, ...rest}) if symbol->isPair(last) => Ok(rest)
        | Ok(_) => Error(symbol)
        | _ => acc
        }
      })
    })

  // part 1
  intermediate
  ->map(x =>
    switch x {
    | Error(symbol) => getErrPoints(symbol)
    | _ => 0
    }
  )
  ->reduce(0, \"+")
  ->Js.log

  // part 2
  intermediate
  ->filterMap(x =>
    switch x {
    | Ok(stack) =>
      stack
      ->Belt.List.reduce(Int64.zero, (acc, x) => {
        open Int64
        acc->mul(of_int(5))->add(getCompPoints(x)->of_int)
      })
      ->Some
    | _ => None
    }
  )
  ->sort(Int64.compare)
  ->(arr => arr[(arr->length - 1) / 2]->exn)
  ->Int64.to_string
  ->Js.log
})
