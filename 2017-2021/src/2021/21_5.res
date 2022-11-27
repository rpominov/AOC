open Tools

module HashMap = Belt.HashMap

module PointHash = Belt.Id.MakeHashable({
  type t = (int, int)
  let hash = ((x, y)) => x * 10000000 + y
  let eq = ((x1, y1), (x2, y2)) => x1 == x2 && y1 == y2
})

let go = (from, dest, step) => {
  from < dest ? from + step : from - step
}

AoC.getInput("2021", "5", input_ => {
  let input =
    input_
    ->lines
    ->map(line => {
      let points =
        line
        ->split(" -> ")
        ->map(point => {
          let xy = point->split(",")->map(string_to_int_unsafe)
          (xy[0]->exn, xy[1]->exn)
        })
      (points[0]->exn, points[1]->exn)
    })

  let coveredPoints = HashMap.make(~hintSize=100000, ~id=module(PointHash))

  let addPoint = point => {
    HashMap.set(
      coveredPoints,
      point,
      switch HashMap.get(coveredPoints, point) {
      | None => 1
      | Some(x) => x + 1
      },
    )
  }

  input->Belt.Array.forEach((((x1, y1), (x2, y2))) => {
    if x1 == x2 {
      for y in Js.Math.min_int(y1, y2) to Js.Math.max_int(y1, y2) {
        addPoint((x1, y))
      }
    } else if y1 == y2 {
      for x in Js.Math.min_int(x1, x2) to Js.Math.max_int(x1, x2) {
        addPoint((x, y1))
      }
    } /* else {
      for s in 0 to abs(x1 - x2) {
        addPoint((go(x1, x2, s), go(y1, y2, s)))
      }
    }*/
  })

  Js.log(coveredPoints->HashMap.valuesToArray->filter(x => x >= 2)->length)
})
