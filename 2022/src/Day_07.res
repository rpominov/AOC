module S = Js.String2
module A = Js.Array2
module M = Belt.MutableMap.String
module O = Belt.Option
module F = Belt.Float

let part1 = input => {
  let cwd = []
  let sizes = M.make()

  input
  ->S.split("\n")
  ->A.forEach(line => {
    switch line->S.split(" ") {
    | ["$", "cd", ".."] => cwd->A.pop->ignore
    | ["$", "cd", dir] => cwd->A.push(dir)->ignore
    | ["$", "ls"] => ()
    | ["dir", _] => ()
    | [size, _] =>
      let path = []
      cwd->A.forEach(dir => {
        path->A.push(dir)->ignore
        let key = path->A.joinWith("/")
        sizes->M.set(key, sizes->M.get(key)->O.getWithDefault(0.) +. size->F.fromString->O.getExn)
      })
    | _ => failwith("invalid input")
    }
  })

  sizes->M.valuesToArray->A.filter(v => v <= 100000.)->A.reduce(\"+.", 0.)
}

let part2 = input => {
  let cwd = []
  let sizes = M.make()

  input
  ->S.split("\n")
  ->A.forEach(line => {
    switch line->S.split(" ") {
    | ["$", "cd", ".."] => cwd->A.pop->ignore
    | ["$", "cd", dir] => cwd->A.push(dir)->ignore
    | ["$", "ls"] => ()
    | ["dir", _] => ()
    | [size, _] =>
      let path = []
      cwd->A.forEach(dir => {
        path->A.push(dir)->ignore
        let key = path->A.joinWith("/")
        sizes->M.set(key, sizes->M.get(key)->O.getWithDefault(0.) +. size->F.fromString->O.getExn)
      })
    | _ => failwith("invalid input")
    }
  })

  let needToDelete = 30000000. +. sizes->M.get("/")->O.getExn -. 70000000.

  (
    sizes
    ->M.valuesToArray
    ->A.filter(v => v >= needToDelete)
    ->A.sortInPlaceWith((a, b) => a === b ? 0 : a < b ? -1 : 1)
  )[0]
}
