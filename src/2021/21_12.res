open Tools
module Map = Belt.Map.String

let addPath = (mapping, a, b) => {
  mapping->Map.set(a, [b]->concat(mapping->Map.getWithDefault(a, [])))
}

let isBig = cave => cave->Js.String.toUpperCase == cave

// for part 1
let canVisit1 = (visited, cave) => isBig(cave) || visited->includes(cave)->not

// for part 2
let canVisit2 = (visited, cave) =>
  isBig(cave) ||
  visited->includes(cave)->not ||
  (cave != "start" &&
    visited->somei((x, i, a) => !isBig(x) && a->sliceFrom(i + 1)->includes(x))->not)

let rec getPathsToTheEnd = (mapping, visited, current) => {
  switch current {
  | "end" => [visited]
  | x if canVisit2(visited, x) =>
    mapping->Map.getWithDefault(x, [])->flatMap(mapping->getPathsToTheEnd(visited->concat([x])))
  | _ => []
  }
}

AoC.getInput("2021", "12", input_ => {
  let mapping =
    input_
    ->lines
    ->reduce(Map.empty, (acc, line) => {
      switch line->split("-") {
      | [a, b] => acc->addPath(a, b)->addPath(b, a)
      | _ => failwith(line)
      }
    })

  mapping->getPathsToTheEnd([], "start")->length->Js.log
})
