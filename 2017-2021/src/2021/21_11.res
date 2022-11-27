open Tools

let slice3 = (arr, middle) =>
  arr->Js.Array2.slice(~start=Js.Math.max_int(0, middle - 1), ~end_=middle + 2)

let charged = x => x > 9

let rec flash = grid => {
  let grid' = grid->mapi((line, i, _) =>
    line->mapi((el, j, _) => {
      switch el {
      | 0 => 0
      | x if x->charged => 0
      | x => x + grid->slice3(i)->map(slice3(_, j))->flat->filter(charged)->length
      }
    })
  )
  grid'->flat->some(charged) ? flash(grid') : grid'
}

let step = grid => {
  grid->map(map(_, x => x + 1))->flash
}

AoC.getInput("2021", "11", input_ => {
  let grid = input_->lines->map(line => line->split("")->map(string_to_int_unsafe))

  let rec part1 = (grid, stepCount, flashCount) => {
    let grid' = step(grid)
    let flashCount' = flashCount + grid'->flat->filter(x => x == 0)->length
    stepCount == 100 ? flashCount' : part1(grid', stepCount + 1, flashCount')
  }
  part1(grid, 1, 0)->Js.log

  let rec part2 = (grid, stepCount) => {
    let grid' = step(grid)
    grid'->flat->every(x => x == 0) ? stepCount : part2(grid', stepCount + 1)
  }
  part2(grid, 1)->Js.log
})
