open Tools

type status = Empty | Occupied | Floor

let sumByDirection = f =>
  f(. -1, -1) +
  f(. -1, 0) +
  f(. -1, 1) +
  f(. 0, -1) +
  f(. 0, 1) +
  f(. 1, -1) +
  f(. 1, 0) +
  f(. 1, 1)

let countOccupied1 = (state, x, y) =>
  sumByDirection((. xDir, yDir) =>
    switch state[y + yDir] {
    | None => 0
    | Some(row) => row[x + xDir] === Some(Occupied) ? 1 : 0
    }
  )

let countOccupied2 = state => {
  let rec seesOccupied = (x, y, xDir, yDir) => {
    let x' = x + xDir
    let y' = y + yDir
    switch state[y'] {
    | None => 0
    | Some(row) =>
      switch row[x'] {
      | None
      | Some(Empty) => 0
      | Some(Occupied) => 1
      | Some(Floor) => seesOccupied(x', y', xDir, yDir)
      }
    }
  }

  (x, y) => sumByDirection((. xDir, yDir) => seesOccupied(x, y, xDir, yDir))
}

let rec stepUntillStable = (state, countOccupied, intolerable) => {
  let countOccupied' = countOccupied(state)

  let state' = state->mapiPreserveRef((row, y) =>
    row->mapiPreserveRef((val, x) =>
      switch val {
      | Empty if countOccupied'(x, y) == 0 => Occupied
      | Occupied if countOccupied'(x, y) >= intolerable => Empty
      | _ => val
      }
    )
  )

  state === state' ? state : state'->stepUntillStable(countOccupied, intolerable)
}

AoC.getInput("2020", "11", input => {
  let initilaState =
    input
    ->lines
    ->map(line =>
      line
      ->split("")
      ->map(x =>
        switch x {
        | "." => Floor
        | "L" => Empty
        | _ => failwith(x)
        }
      )
    )

  initilaState
  ->stepUntillStable(countOccupied1, 4)
  ->flat
  ->count(x => x === Occupied)
  ->Js.log2("part 1:", _)

  initilaState
  ->stepUntillStable(countOccupied2, 5)
  ->flat
  ->count(x => x === Occupied)
  ->Js.log2("part 2:", _)
})
