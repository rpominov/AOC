module S = Js.String2
module A = Js.Array2
module O = Belt.Option
module St = Belt.MutableSet.String
module M = Belt.MutableMap.String

let textToGrid = (text, map) => {
  let lines = text->S.split("\n")
  let width = lines->A.map(S.length)->Js.Math.maxMany_int
  lines->A.map(line =>
    line->S.concat(S.repeat(" ", width - line->S.length))->S.split("")->A.map(map)
  )
}

let traverseGrid = (grid, direction, fn) => {
  let height = grid->A.length
  let width = height === 0 ? 0 : grid[0]->A.length
  switch direction {
  | #lrtb =>
    for y in 0 to height - 1 {
      for x in 0 to width - 1 {
        fn(grid[y][x], x, y, x === 0)
      }
    }
  | #rltb =>
    for y in 0 to height - 1 {
      for x in 0 to width - 1 {
        let x' = width - 1 - x
        fn(grid[y][x'], x', y, x === 0)
      }
    }
  | #tbrl =>
    for x in 0 to width - 1 {
      for y in 0 to height - 1 {
        fn(grid[y][x], x, y, y === 0)
      }
    }
  | #btrl =>
    for x in 0 to width - 1 {
      for y in 0 to height - 1 {
        let y' = height - 1 - y
        fn(grid[y'][x], x, y', y === 0)
      }
    }
  }
}

let key = (x, y) => S.make(x) ++ "," ++ S.make(y)

let part1 = input => {
  let grid = input->textToGrid(int_of_string)

  let visible = St.make()

  [#lrtb, #rltb, #tbrl, #btrl]->A.forEach(direction => {
    let max = ref(-1)

    grid->traverseGrid(direction, (item, x, y, isStart) => {
      if isStart {
        max := -1
      }
      if item > max.contents {
        max := item
        visible->St.add(key(x, y))
      }
    })
  })

  visible->St.size
}

let part2 = input => {
  let grid = input->textToGrid(int_of_string)

  let maps = []

  [#lrtb, #rltb, #tbrl, #btrl]->A.forEach(direction => {
    let map = M.make()
    maps->A.push(map)->ignore
    let trees = ref([])
    grid->traverseGrid(direction, (item, x, y, isStart) => {
      if isStart {
        trees := []
      }
      map->M.set(key(x, y), trees.contents->A.copy->A.reverseInPlace)
      trees.contents->A.push(item)->ignore
    })
  })

  let bestScore = ref(0)

  grid->traverseGrid(#lrtb, (item, x, y, _) => {
    let score =
      maps
      ->A.map(map => {
        let trees = map->M.getExn(key(x, y))
        let index = trees->A.findIndex(x => x >= item)
        if index === -1 {
          trees->A.length
        } else {
          index + 1
        }
      })
      ->A.reduce(\"*", 1)

    if score > bestScore.contents {
      bestScore := score
    }
  })

  bestScore.contents
}
