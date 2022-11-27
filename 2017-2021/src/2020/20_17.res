open Tools

module Set = Belt.Set

type point = {x: int, y: int, z: int, w: int}

let comparePoints = (a, b) =>
  switch a.x - b.x {
  | 0 =>
    switch a.y - b.y {
    | 0 =>
      switch a.z - b.z {
      | 0 => a.w - b.w
      | e => e
      }
    | d => d
    }
  | c => c
  }

module PointComparator = Belt.Id.MakeComparable({
  type t = point
  let cmp = comparePoints
})

let fromArray = Set.fromArray(_, ~id=module(PointComparator))

let neighbourhood = point =>
  [-1, 0, 1]
  ->map(x =>
    [-1, 0, 1]->map(y =>
      [-1, 0, 1]->map(z =>
        [0 /* -1, 1 */]->map(w => {
          x: point.x + x,
          y: point.y + y,
          z: point.z + z,
          w: point.w + w,
        })
      )
    )
  )
  ->flat3
  ->filter(p => comparePoints(p, point) != 0)

let step = active => {
  let toConsider =
    active
    ->Set.toArray
    ->flatMap(point => point->neighbourhood->concat([point]))
    ->fromArray
    ->Set.toArray

  toConsider
  ->filter(point => {
    let activeNeighbours = point->neighbourhood->count(Set.has(active))
    switch (active->Set.has(point), activeNeighbours) {
    | (true, 2) | (_, 3) => true
    | _ => false
    }
  })
  ->fromArray
}

AoC.getInput("2020", "17", input_ => {
  let initilaActive =
    input_
    ->lines
    ->mapi((line, y, _) =>
      line->split("")->mapi((v, x, _) => v == "#" ? Some({x: x, y: y, z: 0, w: 0}) : None)
    )
    ->flat
    ->filterMap(a => a)
    ->fromArray

  initilaActive->step->step->step->step->step->step->Set.size->Js.log
})
