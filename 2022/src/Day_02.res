let part1 = input => {
  let rounds =
    input
    ->Js.String2.trim
    ->Js.String2.split("\n")
    ->Js.Array2.map(line => {
      switch line->Js.String2.split(" ") {
      | [a, b] => (a, b)
      | _ => failwith("invalid input: " ++ line)
      }
    })

  rounds->Js.Array2.reduce((acc, (a, b)) => {
    let forOutcome = switch (a, b) {
    | ("A", "X") | ("B", "Y") | ("C", "Z") => 3
    | ("C", "X") | ("A", "Y") | ("B", "Z") => 6
    | _ => 0
    }

    let forChoice = switch b {
    | "X" => 1
    | "Y" => 2
    | "Z" => 3
    | _ => 0
    }

    acc + forOutcome + forChoice
  }, 0)
}

let part2 = input => {
  let rounds =
    input
    ->Js.String2.trim
    ->Js.String2.split("\n")
    ->Js.Array2.map(line => {
      switch line->Js.String2.split(" ") {
      | [a, b] => (a, b)
      | _ => failwith("invalid input: " ++ line)
      }
    })

  rounds->Js.Array2.reduce((acc, (a, b)) => {
    let forOutcome = switch b {
    | "Y" => 3
    | "Z" => 6
    | _ => 0
    }

    let choice = switch b {
    | "Z" =>
      switch a {
      | "A" => "B"
      | "B" => "C"
      | "C" => "A"
      | v => v
      }
    | "Y" => a
    | "X" =>
      switch a {
      | "B" => "A"
      | "C" => "B"
      | "A" => "C"
      | v => v
      }
    | _ => a
    }

    let forChoice = switch choice {
    | "A" => 1
    | "B" => 2
    | "C" => 3
    | _ => 0
    }

    acc + forOutcome + forChoice
  }, 0)
}
