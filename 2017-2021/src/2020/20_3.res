open Tools

let atCoords = (grid, x, y) => {
  let row = grid->unsafe_at(y)
  row->unsafe_at(x->mod(row->length))
}

type slope = {down: int, right: int}

AoC.getInput("2020", "3", input_ => {
  let grid = input_->lines->map(split(_, ""))

  let treesAtSlope = slope =>
    range(0, grid->length / slope.down - 1)->count(step =>
      grid->atCoords(step * slope.right, step * slope.down) == "#"
    )

  {right: 3, down: 1}->treesAtSlope->Js.log2("part 1:", _)

  [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
  ->map(((r, d)) => treesAtSlope({right: r, down: d})->int_to_float)
  ->reduce(1., \"*.")
  ->Js.log2("part 2:", _)
})
