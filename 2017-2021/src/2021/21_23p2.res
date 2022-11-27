open Tools
module List = Belt.List
module Map = Belt.Map

// h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11
//       a4    b4    c4    d4
//       a3    b3    c3    d3
//       a2    b2    c2    d2
//       a1    b1    c1    d1
type node = [
  | #h1
  | #h2
  | #h3
  | #h4
  | #h5
  | #h6
  | #h7
  | #h8
  | #h9
  | #h10
  | #h11
  | #a1
  | #a2
  | #a3
  | #a4
  | #b1
  | #b2
  | #b3
  | #b4
  | #c1
  | #c2
  | #c3
  | #c4
  | #d1
  | #d2
  | #d3
  | #d4
]

module NodeCmp = Belt.Id.MakeComparable({
  type t = node
  let cmp = (a: node, b: node) => Pervasives.compare((a :> string), (b :> string))
})

type pod = [#a | #b | #c | #d]

let paths =
  [
    [(#h1: node), #h2, #h3, #a4],
    [#h1, #h2, #h3, #a4, #a3],
    [#h1, #h2, #h3, #a4, #a3, #a2],
    [#h1, #h2, #h3, #a4, #a3, #a2, #a1],
    [#h1, #h2, #h3, #h4, #h5, #b4],
    [#h1, #h2, #h3, #h4, #h5, #b4, #b3],
    [#h1, #h2, #h3, #h4, #h5, #b4, #b3, #b2],
    [#h1, #h2, #h3, #h4, #h5, #b4, #b3, #b2, #b1],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #c4],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #c4, #c3],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #c4, #c3, #c2],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #c4, #c3, #c2, #c1],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3, #d2],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3, #d2, #d1],
    //
    [#h2, #h3, #a4],
    [#h2, #h3, #a4, #a3],
    [#h2, #h3, #a4, #a3, #a2],
    [#h2, #h3, #a4, #a3, #a2, #a1],
    [#h2, #h3, #h4, #h5, #b4],
    [#h2, #h3, #h4, #h5, #b4, #b3],
    [#h2, #h3, #h4, #h5, #b4, #b3, #b2],
    [#h2, #h3, #h4, #h5, #b4, #b3, #b2, #b1],
    [#h2, #h3, #h4, #h5, #h6, #h7, #c4],
    [#h2, #h3, #h4, #h5, #h6, #h7, #c4, #c3],
    [#h2, #h3, #h4, #h5, #h6, #h7, #c4, #c3, #c2],
    [#h2, #h3, #h4, #h5, #h6, #h7, #c4, #c3, #c2, #c1],
    [#h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4],
    [#h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3],
    [#h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3, #d2],
    [#h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3, #d2, #d1],
    //
    [#h4, #h3, #a4],
    [#h4, #h3, #a4, #a3],
    [#h4, #h3, #a4, #a3, #a2],
    [#h4, #h3, #a4, #a3, #a2, #a1],
    [#h4, #h5, #b4],
    [#h4, #h5, #b4, #b3],
    [#h4, #h5, #b4, #b3, #b2],
    [#h4, #h5, #b4, #b3, #b2, #b1],
    [#h4, #h5, #h6, #h7, #c4],
    [#h4, #h5, #h6, #h7, #c4, #c3],
    [#h4, #h5, #h6, #h7, #c4, #c3, #c2],
    [#h4, #h5, #h6, #h7, #c4, #c3, #c2, #c1],
    [#h4, #h5, #h6, #h7, #h8, #h9, #d4],
    [#h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3],
    [#h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3, #d2],
    [#h4, #h5, #h6, #h7, #h8, #h9, #d4, #d3, #d2, #d1],
    //
    [#h6, #h5, #b4],
    [#h6, #h5, #b4, #b3],
    [#h6, #h5, #b4, #b3, #b2],
    [#h6, #h5, #b4, #b3, #b2, #b1],
    [#h6, #h5, #h4, #h3, #a4],
    [#h6, #h5, #h4, #h3, #a4, #a3],
    [#h6, #h5, #h4, #h3, #a4, #a3, #a2],
    [#h6, #h5, #h4, #h3, #a4, #a3, #a2, #a1],
    [#h6, #h7, #c4],
    [#h6, #h7, #c4, #c3],
    [#h6, #h7, #c4, #c3, #c2],
    [#h6, #h7, #c4, #c3, #c2, #c1],
    [#h6, #h7, #h8, #h9, #d4],
    [#h6, #h7, #h8, #h9, #d4, #d3],
    [#h6, #h7, #h8, #h9, #d4, #d3, #d2],
    [#h6, #h7, #h8, #h9, #d4, #d3, #d2, #d1],
    //
    [#h8, #h7, #c4],
    [#h8, #h7, #c4, #c3],
    [#h8, #h7, #c4, #c3, #c2],
    [#h8, #h7, #c4, #c3, #c2, #c1],
    [#h8, #h7, #h6, #h5, #b4],
    [#h8, #h7, #h6, #h5, #b4, #b3],
    [#h8, #h7, #h6, #h5, #b4, #b3, #b2],
    [#h8, #h7, #h6, #h5, #b4, #b3, #b2, #b1],
    [#h8, #h7, #h6, #h5, #h4, #h3, #a4],
    [#h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3],
    [#h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3, #a2, #a1],
    [#h8, #h9, #d4],
    [#h8, #h9, #d4, #d3],
    [#h8, #h9, #d4, #d3, #d2],
    [#h8, #h9, #d4, #d3, #d2, #d1],
    //
    [#h10, #h9, #d4],
    [#h10, #h9, #d4, #d3],
    [#h10, #h9, #d4, #d3, #d2],
    [#h10, #h9, #d4, #d3, #d2, #d1],
    [#h10, #h9, #h8, #h7, #c4],
    [#h10, #h9, #h8, #h7, #c4, #c3],
    [#h10, #h9, #h8, #h7, #c4, #c3, #c2],
    [#h10, #h9, #h8, #h7, #c4, #c3, #c2, #c1],
    [#h10, #h9, #h8, #h7, #h6, #h5, #b4],
    [#h10, #h9, #h8, #h7, #h6, #h5, #b4, #b3],
    [#h10, #h9, #h8, #h7, #h6, #h5, #b4, #b3, #b2],
    [#h10, #h9, #h8, #h7, #h6, #h5, #b4, #b3, #b2, #b1],
    [#h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4],
    [#h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3],
    [#h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3, #a2],
    [#h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3, #a2, #a1],
    //
    [#h11, #h10, #h9, #d4],
    [#h11, #h10, #h9, #d4, #d3],
    [#h11, #h10, #h9, #d4, #d3, #d2],
    [#h11, #h10, #h9, #d4, #d3, #d2, #d1],
    [#h11, #h10, #h9, #h8, #h7, #c4],
    [#h11, #h10, #h9, #h8, #h7, #c4, #c3],
    [#h11, #h10, #h9, #h8, #h7, #c4, #c3, #c2],
    [#h11, #h10, #h9, #h8, #h7, #c4, #c3, #c2, #c1],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #b4],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #b4, #b3],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #b4, #b3, #b2],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #b4, #b3, #b2, #b1],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3, #a2],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a4, #a3, #a2, #a1],
  ]
  ->(arr => arr->concat(arr->map(Belt.Array.reverse)))
  ->map(p => (p[0]->exn, p->last->unsafe, p->sliceFrom(1)))

// let distances =
//   paths
//   ->map(((f, l, r)) => ((f :> string) ++ "-" ++ (l :> string), r->length))
//   ->Map.String.fromArray
// let getDistnace = (a: node, b: node) =>
//   a == b ? 0 : distances->Map.String.get((a :> string) ++ "-" ++ (b :> string))->unsafe

let getCost = pod =>
  switch pod {
  | #a => 1
  | #b => 10
  | #c => 100
  | #d => 1000
  }

type class = Hallway(int, int, int, int) | Room(pod, list<node>, int)
let classify = (node: node) =>
  switch node {
  | #h1 => Hallway(2, 4, 6, 8)
  | #h2 => Hallway(1, 3, 5, 7)
  | #h4 => Hallway(1, 1, 3, 5)
  | #h6 => Hallway(3, 1, 1, 3)
  | #h8 => Hallway(5, 3, 1, 1)
  | #h10 => Hallway(7, 5, 3, 1)
  | #h11 => Hallway(8, 6, 4, 2)
  | #h5
  | #h7
  | #h9
  | #h3 =>
    Hallway(0, 0, 0, 0)
  | #a4 => Room(#a, list{#a3, #a2, #a1}, 0)
  | #a3 => Room(#a, list{#a2, #a1}, 1)
  | #a2 => Room(#a, list{#a1}, 2)
  | #a1 => Room(#a, list{}, 3)
  | #b4 => Room(#b, list{#b3, #b2, #b1}, 0)
  | #b3 => Room(#b, list{#b2, #b1}, 1)
  | #b2 => Room(#b, list{#b1}, 2)
  | #b1 => Room(#b, list{}, 3)
  | #c4 => Room(#c, list{#c3, #c2, #c1}, 0)
  | #c3 => Room(#c, list{#c2, #c1}, 1)
  | #c2 => Room(#c, list{#c1}, 2)
  | #c1 => Room(#c, list{}, 3)
  | #d4 => Room(#d, list{#d3, #d2, #d1}, 0)
  | #d3 => Room(#d, list{#d2, #d1}, 1)
  | #d2 => Room(#d, list{#d1}, 2)
  | #d1 => Room(#d, list{}, 3)
  }

let roomsDist = (a, b) => {
  switch (a, b) {
  | (#a, #b) | (#b, #a) => 2
  | (#c, #b) | (#b, #c) => 2
  | (#c, #d) | (#d, #c) => 2
  | (#a, #c) | (#c, #a) => 4
  | (#b, #d) | (#d, #b) => 4
  | (#a, #d) | (#d, #a) => 6
  | _ => 0
  }
}

let canStartAt = (pod, pos, state) => {
  switch classify(pos) {
  | Room(roomPod, below, _) =>
    roomPod != pod || below->List.some(n => state->Map.get(n) !== Some(pod))
  | _ => true
  }
}

let canEndAt = (pod, pos, state) => {
  switch classify(pos) {
  | Room(roomPod, below, _) =>
    roomPod === pod && below->List.every(n => state->Map.get(n) === Some(pod))
  | _ => true
  }
}

let allowedPaths = state =>
  state
  ->Map.toArray
  ->flatMap(((node, pod)) =>
    if canStartAt(pod, node, state) {
      paths->filter(((first, last, rest)) =>
        first == node && canEndAt(pod, last, state) && rest->every(n => state->Map.has(n)->not)
      )
    } else {
      []
    }
  )

let isDone = state =>
  state->Map.every((k, v) =>
    switch classify(k) {
    | Room(pod, _, _) => pod === v
    | _ => false
    }
  )

let minCost = state =>
  state->Map.reduce(0, (acc, k, v) =>
    acc +
    switch classify(k) {
    | Hallway(da, db, dc, dd) =>
      switch v {
      | #a => da
      | #b => db
      | #c => dc
      | #d => dd
      } + 1
    | Room(roomPod, _, _) if roomPod === v => 0
    | Room(roomPod, _, costToHall) => costToHall + roomsDist(roomPod, v) + 2
    } *
    getCost(v)
  )

let rec findBest = (best, jobs) => {
  switch jobs[0] {
  | None => best
  | Some((cost, state)) => {
      let jobs' = jobs->rest
      if isDone(state) {
        Js.log(cost)
        findBest(cost, jobs')
      } else if cost + minCost(state) >= best {
        findBest(best, jobs')
      } else {
        switch allowedPaths(state) {
        | [] => findBest(best, jobs')
        | paths =>
          findBest(
            best,
            paths
            ->filterMap(((first, last, rest)) => {
              let pod = state->Map.get(first)->unsafe
              let cost' = cost + rest->length * pod->getCost
              if best <= cost' {
                None
              } else {
                let state' = state->Map.remove(first)->Map.set(last, pod)
                Some((cost', state'))
              }
            })
            ->concat(jobs'),
          )
        }
      }
    }
  }
}

AoC.getInput("2021", "23", input => {
  let initialState =
    [#a4, #b4, #c4, #d4, #a1, #b1, #c1, #d1, #a3, #b3, #c3, #d3, #a2, #b2, #c2, #d2]
    ->Belt.Array.zip(
      (input ++ "DCBA" ++ "DBAC")
      ->split("")
      ->filterMap(ch =>
        switch ch {
        | "A" => Some(#a)
        | "B" => Some(#b)
        | "C" => Some(#c)
        | "D" => Some(#d)
        | _ => None
        }
      ),
    )
    ->Map.fromArray(~id=module(NodeCmp))

  findBest(1000000, [(0, initialState)])->Js.log
})
