open Tools

let range = (min, max) =>
  min <= max ? Belt.Array.range(min, max) : Belt.Array.range(max, min)->Belt.Array.reverse

// Not sure this works for any input.
// "Not proven" below means I don't have a proof that it works,
// I only observed it worked with these conditions.
AoC.getInput("2021", "17", input_ => {
  let (minX, maxX, minY, maxY) = switch input_
  ->Js.String2.trim
  ->Js.String2.replace("target area: ", "")
  ->split(", ")
  ->map(a => (a->split("="))[1]->exn->split("..")->map(string_to_int_unsafe)) {
  | [[minX, maxX], [minY, maxY]] => (minX, maxX, minY, maxY)
  | _ => failwith(`Cant parse: ${input_}`)
  }

  // part 1
  let rec maxY_ifHit = (vel, pos, max) => {
    let pos' = pos + vel
    let max' = Js.Math.max_int(pos', max)
    if pos' <= maxY && pos' >= minY {
      Ok(max')
    } else if pos' < minY {
      Error(pos)
    } else {
      maxY_ifHit(vel - 1, pos', max')
    }
  }
  let rec getMaxY = (vel, max) => {
    switch maxY_ifHit(vel, 0, 0) {
    | Ok(v) => getMaxY(vel + 1, v)
    | Error(p) if p == 0 => max // Not proven
    | Error(_) => getMaxY(vel + 1, max)
    }
  }
  getMaxY(0, 0)->Js.log

  // part 2

  let rec doesHit = (~trace=false, vx, vy, px, py) => {
    let px' = px + vx
    let py' = py + vy
    let vx' = vx == 0 ? 0 : vx - 1
    let vy' = vy - 1

    if trace {
      Js.log((px', py'))
    }

    if vx == 0 && px' < minX {
      #didn_reach
    } else if px' > maxX && px == 0 {
      #went_over_x0
    } else if py' < minY && py == 0 {
      #went_over_y0
    } else if py' < minY {
      #went_over_y1
    } else if px' > maxX {
      #went_over_x1
    } else if px' >= minX && px' <= maxX && py' <= maxY && py' >= minY {
      #hit
    } else {
      doesHit(vx', vy', px', py', ~trace)
    }
  }

  let rec getYs1 = (acc, x) => {
    let y = acc->length + 1
    let outcome = doesHit(x, y, 0, 0)
    let acc' = acc->concat([outcome])

    switch outcome {
    | #didn_reach | #went_over_x1 | #went_over_x0 | #went_over_y0 => acc' // Not proven
    | _ => acc'->getYs1(x)
    }
  }

  let rec getYs2 = (acc, x) => {
    let y = acc->length * -1
    let outcome = doesHit(x, y, 0, 0)
    let acc' = acc->concat([outcome])

    if outcome == #went_over_x1 {
      Js.log(j`$x, $y ===== went_over_x1`)
      doesHit(x, y, 0, 0, ~trace=true)->ignore
      Js.log("============")
    }

    if outcome == #hit {
      Js.log(j`$x, $y ===== hit`)
      doesHit(x, y, 0, 0, ~trace=true)->ignore
      Js.log("============")
    }

    switch outcome {
    // Not proven, and I don't understand why we want #went_over_x1 above, but not here
    | #didn_reach | #went_over_x0 | #went_over_y0 => acc'
    | _ => acc'->getYs2(x)
    }
  }

  range(1, maxX)
  ->map(x => getYs2([], x)->concat(getYs1([], x)))
  ->flat
  ->filter(a => a == #hit)
  ->length
  ->Js.log
})
