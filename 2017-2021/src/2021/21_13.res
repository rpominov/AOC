open Tools
module Set = Belt.Set

type fold = XFold(int) | YFold(int)

module PointComparator = Belt.Id.MakeComparable({
  type t = (int, int)
  let cmp = ((a0, a1), (b0, b1)) =>
    switch a0 - b0 {
    | 0 => a1 - b1
    | c => c
    }
})

let foldBy = (points, fold) =>
  points
  ->Set.toArray
  ->map(point =>
    switch (fold, point) {
    | (XFold(fx), (x, _)) if x < fx => point
    | (XFold(fx), (x, y)) => (fx * 2 - x, y)
    | (YFold(fy), (_, y)) if y < fy => point
    | (YFold(fy), (x, y)) => (x, fy * 2 - y)
    }
  )
  ->Set.fromArray(~id=module(PointComparator))

AoC.getInput("2021", "13", input_ => {
  let (dots_, folds_) = switch input_->split("\n\n") {
  | [a, b] => (a, b)
  | _ => failwith("bad input")
  }

  let dots =
    dots_
    ->lines
    ->map(line =>
      switch line->split(",")->map(string_to_int_unsafe) {
      | [x, y] => (x, y)
      | _ => failwith("bad line:" ++ line)
      }
    )
    ->Set.fromArray(~id=module(PointComparator))

  let folds =
    folds_
    ->lines
    ->map(line =>
      switch line->split("=") {
      | ["fold along y", y] => YFold(y->string_to_int_unsafe)
      | ["fold along x", x] => XFold(x->string_to_int_unsafe)
      | _ => failwith("bad line:" ++ line)
      }
    )

  // part 1
  dots->foldBy(folds[0]->exn)->Set.toArray->length->Js.log

  // part 2
  let finalDots = folds->reduce(dots, foldBy)
  let maxX = finalDots->Set.toArray->map(((x, _)) => x)->Js.Math.maxMany_int
  let maxY = finalDots->Set.toArray->map(((_, y)) => y)->Js.Math.maxMany_int
  for y in 0 to maxY {
    Tools.range(0, maxX)->map(x => finalDots->Set.has((x, y)) ? "8" : " ")->join("")->Js.log
  }
})
