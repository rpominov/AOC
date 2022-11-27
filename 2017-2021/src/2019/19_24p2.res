open Tools

let maxXY = 4
let middle = 2
let empty = range(0, maxXY)->map(_ => range(0, maxXY)->map(_ => 0))
let get = (state, z, x, y) =>
  z < 0 || z >= state->length ? 0 : state->unsafe_at(z)->unsafe_at(y)->unsafe_at(x)
let inRange = Point.inRange(_, Point.make(0, 0), Point.make(maxXY, maxXY))

let adjacentSum = (state, z, x, y) =>
  Navigation.sumByDirection(direction => {
    let adj = Navigation.move(x, y, direction)
    if adj.x === middle && adj.y === middle {
      rangeSum(0, maxXY, i =>
        switch direction {
        | W => get(state, z + 1, maxXY, i)
        | E => get(state, z + 1, 0, i)
        | S => get(state, z + 1, i, maxXY)
        | N => get(state, z + 1, i, 0)
        }
      )
    } else if inRange(adj) {
      state->get(z, adj.x, adj.y)
    } else {
      let adj' = Navigation.move(middle, middle, direction)
      state->get(z - 1, adj'.x, adj'.y)
    }
  })

let step = state =>
  [[empty], state, [empty]]
  ->flat
  ->mapi((layer, z, state') =>
    layer->mapi((row, y, _) =>
      row->mapi((v, x, _) =>
        x === middle && y === middle
          ? 0
          : switch state'->adjacentSum(z, x, y) {
            | 1 => 1
            | 2 if v === 0 => 1
            | _ => 0
            }
      )
    )
  )

AoC.getInput("2019", "24", input => {
  let initial =
    input
    ->lines
    ->map(line =>
      line
      ->split("")
      ->map(x =>
        switch x {
        | "#" => 1
        | "." => 0
        | _ => failwith(x)
        }
      )
    )

  range(1, 200)
  ->reduce([initial], (acc, _) => acc->step)
  ->flat2
  ->reduce(0, \"+")
  ->Js.log2("part 2:", _)
})
