open Tools

type t = {x: int, y: int}

let make = (x, y) => {x: x, y: y}
let x = p => p.x
let y = p => p.y

let toPair = p => (p.x, p.y)

let add = (a, b) => make(a.x + b.x, a.y + b.y)
let shiftBy = (p, (x, y)) => make(p.x + x, p.y + y)

let inRange = (p, min, max) => p.x >= min.x && p.y >= min.y && p.x <= max.x && p.y <= max.y

let eq = (a, b) => a.x == b.x && a.y == b.y

let cmp = (a, b) =>
  switch a.x - b.x {
  | 0 => a.y - b.y
  | c => c
  }

module Comparable = Belt.Id.MakeComparable({
  type t = t
  let cmp = cmp
})

module Hashable = Belt.Id.MakeHashable({
  type t = t
  // no collisions for x and y each in [0, 32767]
  // (less collisions - faster hash table)
  let hash = p => p.x * 32768 /* 2^15 */ + p.y
  let eq = eq
})

let arrAt = (arr, point) =>
  switch arr[point.y] {
  | Some(line) => line[point.x]
  | _ => None
  }
