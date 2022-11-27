open Tools

module Map = Belt.Map
module Option = Belt.Option

let collect = pairs =>
  pairs->reduce(Map.String.empty, (acc, (k, v)) => {
    acc->Map.String.set(k, acc->Map.String.getWithDefault(k, Int64.zero)->Int64.add(v))
  })

AoC.getInput("2021", "14", input_ => {
  let (seq, rules) = switch input_->split("\n\n") {
  | [a, b] => (
      a->split(""),
      b
      ->lines
      ->map(line =>
        switch line->split(" -> ") {
        | [c, d] => (c, d)
        | _ => failwith("bad line: " ++ line)
        }
      )
      ->Map.String.fromArray,
    )
  | _ => failwith("bad input")
  }

  Tools.range(1, 40)
  ->reduce(
    seq
    ->mapi((a, i, _) => seq[i + 1]->Option.map(b => (a ++ b, Int64.one)))
    ->filterMap(x => x)
    ->collect,
    (acc, _) =>
      acc
      ->Map.String.toArray
      ->map(((pair, count)) =>
        switch rules->Map.String.get(pair) {
        | Some(x) => [(pair->Js.String2.get(0) ++ x, count), (x ++ pair->Js.String2.get(1), count)]
        | _ => [(pair, count)]
        }
      )
      ->flat
      ->collect,
  )
  ->Map.String.toArray
  ->map(((k, v)) => (k->Js.String2.get(1), v))
  ->collect
  ->Map.String.toArray
  ->map(((k, v)) => k == seq[0]->exn ? v->Int64.add(Int64.one) : v)
  ->sort(Int64.compare)
  ->(arr => arr->last->unsafe->Int64.sub(arr[0]->exn))
  ->Int64.to_string
  ->Js.log
})
