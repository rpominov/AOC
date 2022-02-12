open Tools
module Set = Belt.Set

let rec followDirections = (start: Point.t, data) => {
  let evenRow = mod(start.y, 2) === 0
  switch switch (data[0], data[1]) {
  | (Some("e"), _) => (1, 0, 1)->Some
  | (Some("w"), _) => (-1, 0, 1)->Some
  | (Some("n"), Some("w")) => (evenRow ? -1 : 0, -1, 2)->Some
  | (Some("n"), Some("e")) => (evenRow ? 0 : 1, -1, 2)->Some
  | (Some("s"), Some("w")) => (evenRow ? -1 : 0, 1, 2)->Some
  | (Some("s"), Some("e")) => (evenRow ? 0 : 1, 1, 2)->Some
  | (None, _) => None
  | _ => failwith("bad directions")
  } {
  | None => start
  | Some((x, y, skip)) =>
    followDirections(Point.add(start, Point.make(x, y)), data->sliceFrom(skip))
  }
}

let neighborhood = (start: Point.t) => {
  let evenRow = mod(start.y, 2) === 0
  [
    Point.make(1, 0),
    Point.make(-1, 0),
    Point.make(evenRow ? -1 : 0, -1),
    Point.make(evenRow ? 0 : 1, -1),
    Point.make(evenRow ? -1 : 0, 1),
    Point.make(evenRow ? 0 : 1, 1),
  ]->map(Point.add(start))
}

let neighborhoodCount = (start: Point.t, points) => {
  neighborhood(start)->count(points->Set.has)
}

let step = points =>
  points
  ->Set.keep(p => {
    let count = neighborhoodCount(p, points)
    count === 1 || count === 2
  })
  ->Set.union(
    points
    ->Set.toArray
    ->flatMap(neighborhood)
    ->Set.fromArray(~id=module(Point.Comparable))
    ->Set.keep(p => neighborhoodCount(p, points) === 2),
  )

let flip = (set, v) => set->Set.has(v) ? set->Set.remove(v) : set->Set.add(v)

AoC.getInput("2020", "24", input_ => {
  let initialPattern =
    input_
    ->lines
    ->map(line => line->split("")->followDirections(Point.make(0, 0), _))
    ->reduce(Set.make(~id=module(Point.Comparable)), (acc, point) => acc->flip(point))

  initialPattern->Set.size->Js.log2("part 1:", _)

  range(1, 100)->reduce(initialPattern, (acc, _) => acc->step)->Set.size->Js.log2("part 2:", _)
})
