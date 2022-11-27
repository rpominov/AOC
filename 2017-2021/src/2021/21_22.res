open Tools

module Set = Belt.Set

type split = Left((int, int)) | Right((int, int)) | Both((int, int), (int, int))
let split1d = (low, high, splitBy) =>
  if splitBy < low {
    Right((low, high))
  } else if splitBy >= high {
    Left((low, high))
  } else {
    Both((low, splitBy), (splitBy + 1, high))
  }
let partition1d = (low, high, toSepLow, toSepHigh, f) => {
  switch split1d(low, high, toSepLow - 1) {
  | Right((low, high)) =>
    switch split1d(low, high, toSepHigh) {
    | Left(exc) => ([], Some(f(exc)))
    | Right(inc) => ([f(inc)], None)
    | Both(exc, inc) => ([f(inc)], Some(f(exc)))
    }
  | Both(inc, (low, high)) =>
    switch split1d(low, high, toSepHigh) {
    | Left(exc) => ([f(inc)], Some(f(exc)))
    | Right(inc') => ([f(inc), f(inc')], None)
    | Both(exc, inc') => ([f(inc), f(inc')], Some(f(exc)))
    }
  | Left(inc) => ([f(inc)], None)
  }
}

type cuboid = {low: Point3d.t, high: Point3d.t}

let updX = (cb, (low, high)) => {
  low: Point3d.make(low, cb.low.y, cb.low.z),
  high: Point3d.make(high, cb.high.y, cb.high.z),
}
let updY = (cb, (low, high)) => {
  low: Point3d.make(cb.low.x, low, cb.low.z),
  high: Point3d.make(cb.high.x, high, cb.high.z),
}
let updZ = (cb, (low, high)) => {
  low: Point3d.make(cb.low.x, cb.low.y, low),
  high: Point3d.make(cb.high.x, cb.high.y, high),
}

let cut = (cub, toRemove) =>
  switch partition1d(cub.low.x, cub.high.x, toRemove.low.x, toRemove.high.x, updX(cub)) {
  | (inc, None) => inc
  | (inc, Some(exc)) =>
    inc->concat(
      switch partition1d(exc.low.y, exc.high.y, toRemove.low.y, toRemove.high.y, updY(exc)) {
      | (inc', None) => inc'
      | (inc', Some(exc')) =>
        inc'->concat(
          switch partition1d(exc'.low.z, exc'.high.z, toRemove.low.z, toRemove.high.z, updZ(exc')) {
          | (inc'', _) => inc''
          },
        )
      },
    )
  }

let sub = (acc, new) => {
  acc->map(cut(_, new))->flat
}
let add = (acc, new) => {
  [new]->concat(sub(acc, new))
}

AoC.getInput("2021", "22", input_ => {
  let input =
    input_
    ->lines
    ->map(line =>
      switch line->match_re(
        %re(
          "/^(on|off) x=(-?[0-9]+)..(-?[0-9]+),y=(-?[0-9]+)..(-?[0-9]+),z=(-?[0-9]+)..(-?[0-9]+)$/"
        ),
      ) {
      | Some([_, "on", x1, x2, y1, y2, z1, z2]) => (
          #on,
          Point3d.make(
            x1->string_to_int_unsafe,
            y1->string_to_int_unsafe,
            z1->string_to_int_unsafe,
          ),
          Point3d.make(
            x2->string_to_int_unsafe,
            y2->string_to_int_unsafe,
            z2->string_to_int_unsafe,
          ),
        )
      | Some([_, "off", x1, x2, y1, y2, z1, z2]) => (
          #off,
          Point3d.make(
            x1->string_to_int_unsafe,
            y1->string_to_int_unsafe,
            z1->string_to_int_unsafe,
          ),
          Point3d.make(
            x2->string_to_int_unsafe,
            y2->string_to_int_unsafe,
            z2->string_to_int_unsafe,
          ),
        )
      | _ => failwith(`bad line: ${line}`)
      }
    )

  // part 1
  let inRange = Point3d.inRange(_, Point3d.make(-50, -50, -50), Point3d.make(50, 50, 50))
  input
  ->filter(((_, low, high)) => low->inRange && high->inRange)
  ->reduce(Set.make(~id=module(Point3d.Comparable)), (acc, (inst, low, high)) =>
    acc->(inst == #on ? Set.mergeMany : Set.removeMany)(Point3d.range(low, high))
  )
  ->Set.size
  ->Js.log

  // part 2
  input
  ->reduce([], (acc, (inst, low, high)) => {
    acc->(inst == #on ? add : sub)({low: low, high: high})
  })
  ->map(({low, high}) =>
    (high.x - low.x + 1)->int_to_float *.
    (high.y - low.y + 1)->int_to_float *.
    (high.z - low.z + 1)->int_to_float
  )
  ->reduce(0., \"+.")
  ->Js.log
})
