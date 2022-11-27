open Tools
module Map = Belt.Map

// h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11
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
  | #b1
  | #b2
  | #c1
  | #c2
  | #d1
  | #d2
]

module NodeCmp = Belt.Id.MakeComparable({
  type t = node
  let cmp = (a: node, b: node) => Pervasives.compare((a :> string), (b :> string))
})

type pod = [#a | #b | #c | #d]

let paths =
  [
    [(#h1: node), #h2, #h3, #a2],
    [#h1, #h2, #h3, #a2, #a1],
    [#h1, #h2, #h3, #h4, #h5, #b2],
    [#h1, #h2, #h3, #h4, #h5, #b2, #b1],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #c2],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #c2, #c1],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d2],
    [#h1, #h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d2, #d1],
    //
    [#h2, #h3, #a2],
    [#h2, #h3, #a2, #a1],
    [#h2, #h3, #h4, #h5, #b2],
    [#h2, #h3, #h4, #h5, #b2, #b1],
    [#h2, #h3, #h4, #h5, #h6, #h7, #c2],
    [#h2, #h3, #h4, #h5, #h6, #h7, #c2, #c1],
    [#h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d2],
    [#h2, #h3, #h4, #h5, #h6, #h7, #h8, #h9, #d2, #d1],
    //
    [#h4, #h3, #a2],
    [#h4, #h3, #a2, #a1],
    [#h4, #h5, #b2],
    [#h4, #h5, #b2, #b1],
    [#h4, #h5, #h6, #h7, #c2],
    [#h4, #h5, #h6, #h7, #c2, #c1],
    [#h4, #h5, #h6, #h7, #h8, #h9, #d2],
    [#h4, #h5, #h6, #h7, #h8, #h9, #d2, #d1],
    //
    [#h6, #h5, #b2],
    [#h6, #h5, #b2, #b1],
    [#h6, #h5, #h4, #h3, #a2],
    [#h6, #h5, #h4, #h3, #a2, #a1],
    [#h6, #h7, #c2],
    [#h6, #h7, #c2, #c1],
    [#h6, #h7, #h8, #h9, #d2],
    [#h6, #h7, #h8, #h9, #d2, #d1],
    //
    [#h8, #h7, #c2],
    [#h8, #h7, #c2, #c1],
    [#h8, #h7, #h6, #h5, #b2],
    [#h8, #h7, #h6, #h5, #b2, #b1],
    [#h8, #h7, #h6, #h5, #h4, #h3, #a2],
    [#h8, #h7, #h6, #h5, #h4, #h3, #a2, #a1],
    [#h8, #h9, #d2],
    [#h8, #h9, #d2, #d1],
    //
    [#h10, #h9, #d2],
    [#h10, #h9, #d2, #d1],
    [#h10, #h9, #h8, #h7, #c2],
    [#h10, #h9, #h8, #h7, #c2, #c1],
    [#h10, #h9, #h8, #h7, #h6, #h5, #b2],
    [#h10, #h9, #h8, #h7, #h6, #h5, #b2, #b1],
    [#h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a2],
    [#h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a2, #a1],
    //
    [#h11, #h10, #h9, #d2],
    [#h11, #h10, #h9, #d2, #d1],
    [#h11, #h10, #h9, #h8, #h7, #c2],
    [#h11, #h10, #h9, #h8, #h7, #c2, #c1],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #b2],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #b2, #b1],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a2],
    [#h11, #h10, #h9, #h8, #h7, #h6, #h5, #h4, #h3, #a2, #a1],
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

let classify = (node: node) =>
  switch node {
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
  | #h11 =>
    #hallway
  | #a2 => #top((#a: pod), (#a1: node))
  | #a1 => #bottom((#a: pod))
  | #b2 => #top(#b, #b1)
  | #b1 => #bottom(#b)
  | #c2 => #top(#c, #c1)
  | #c1 => #bottom(#c)
  | #d2 => #top(#d, #d1)
  | #d1 => #bottom(#d)
  }

let canStartAt = (pod, pos, state) => {
  switch (pod, classify(pos)) {
  | (a, #top(b, c)) if a == b => state->Map.get(c) !== Some(a)
  | (a, #bottom(b)) => a != b
  | _ => true
  }
}

let canEndAt = (pod, pos, state) => {
  switch (pod, classify(pos)) {
  | (x, #top(y, _)) | (x, #bottom(y)) if x != y => false
  | (a, #top(_, c)) => state->Map.get(c) === Some(a)
  | _ => true
  }
}

let allowedPaths = state =>
  state
  ->Map.toArray
  ->map(((node, pod)) =>
    if canStartAt(pod, node, state) {
      paths->filter(((first, last, rest)) =>
        first == node && canEndAt(pod, last, state) && rest->every(n => state->Map.has(n)->not)
      )
    } else {
      []
    }
  )
  ->flat

let isDone = state =>
  state->Map.every((k, v) =>
    switch classify(k) {
    | #top(x, _) | #bottom(x) if x === v => true
    | _ => false
    }
  )

let minCost = state =>
  state->Map.reduce(0, (acc, k, v) =>
    acc +
    switch (k, v) {
    | (#a1, #a)
    | (#a2, #a)
    | (#b1, #b)
    | (#b2, #b)
    | (#c1, #c)
    | (#c2, #c)
    | (#d1, #d)
    | (#d2, #d) => 0
    | (#h2, #a)
    | (#h4, #a)
    | (#h4, #b)
    | (#h6, #b)
    | (#h6, #c)
    | (#h8, #c)
    | (#h8, #d)
    | (#h10, #d) => 2
    | (#h1, #a)
    | (#h11, #d) => 3
    | (#h6, #a)
    | (#b2, #a)
    | (#h2, #b)
    | (#h8, #b)
    | (#a2, #b)
    | (#c2, #b)
    | (#h4, #c)
    | (#h10, #c)
    | (#b2, #c)
    | (#d2, #c)
    | (#h6, #d)
    | (#c2, #d) => 4
    | (#b1, #a)
    | (#a1, #b)
    | (#c1, #b)
    | (#h1, #b)
    | (#b1, #c)
    | (#d1, #c)
    | (#h11, #c)
    | (#c1, #d) => 5
    | _ => 6
    } *
    getCost(v)
  )

let rec findBest = (best, jobs) => {
  switch jobs[0] {
  | None => best
  | Some((cost, state)) => {
      let jobs' = jobs->sliceFrom(1)
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
    [#a2, #b2, #c2, #d2, #a1, #b1, #c1, #d1]
    ->Belt.Array.zip(
      input
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

  findBest(Js.Int.max, [(0, initialState)])->Js.log
})
