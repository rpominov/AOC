open Tools

type status = R | D | N

let print = grid =>
  grid
  ->map(line =>
    line
    ->map(x =>
      switch x {
      | R => ">"
      | D => "v"
      | N => "."
      }
    )
    ->join("")
  )
  ->join("\n")

let prev = (arr, i) => arr->unsafe_at(i - 1 >= 0 ? i - 1 : arr->length - 1)
let next = (arr, i) => arr->unsafe_at(mod(i + 1, arr->length))

let step = grid => {
  let changed = ref(false)
  let m = x => {
    changed := true
    x
  }

  let grid' = grid->map(line =>
    line->mapi((x, i, _) => {
      switch (prev(line, i), x, next(line, i)) {
      | (R, N, _) => m(R)
      | (_, R, N) => m(N)
      | _ => x
      }
    })
  )

  let grid'' = grid'->mapi((line, i, _) =>
    line->mapi((x, j, _) => {
      switch (prev(grid', i), x, next(grid', i)) {
      | (lineAbove, N, _) if lineAbove->unsafe_at(j) == D => m(D)
      | (_, D, lineBelow) if lineBelow->unsafe_at(j) == N => m(N)
      | _ => x
      }
    })
  )

  (grid'', changed.contents)
}

let rec run = (res, grid) => {
  let (grid', changed) = grid->step
  changed ? run(res + 1, grid') : (res, grid)
}

AoC.getInput("2021", "25", input_ => {
  let input =
    input_
    ->lines
    ->map(line =>
      line
      ->split("")
      ->map(ch =>
        switch ch {
        | ">" => R
        | "v" => D
        | _ => N
        }
      )
    )
  let (count, grid) = run(1, input)
  grid->print->Js.log
  count->Js.log
})
