type direction = N | S | E | W

let directions = [N, S, E, W]

let directions8 = [
  (N, None),
  (N, Some(E)),
  (E, None),
  (E, Some(S)),
  (S, None),
  (S, Some(W)),
  (W, None),
  (W, Some(N)),
]

let move = (~distance=1, x, y, direction) =>
  switch direction {
  | N => Point.make(x, y + distance)
  | S => Point.make(x, y - distance)
  | E => Point.make(x + distance, y)
  | W => Point.make(x - distance, y)
  }

let move8 = (~distance=1, x, y, direction) => {
  let p = move(~distance, x, y, direction->fst)
  switch direction->snd {
  | None => p
  | Some(d) => move(~distance, p.x, p.y, d)
  }
}

let sumByDirection = f => f(N) + f(S) + f(E) + f(W)
