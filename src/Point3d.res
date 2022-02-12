open Tools

type t = {x: int, y: int, z: int}

let make = (x, y, z) => {x: x, y: y, z: z}
let x = p => p.x
let y = p => p.y
let z = p => p.z

let fromArray = arr =>
  switch arr {
  | [x, y, z] => Some(make(x, y, z))
  | _ => None
  }

let inRange = (p, min, max) =>
  p.x >= min.x && p.y >= min.y && p.z >= min.z && p.x <= max.x && p.y <= max.y && p.z <= max.z

let range = (min, max) => {
  range(min.x, max.x)
  ->map(x => range(min.y, max.y)->map(y => range(min.z, max.z)->map(z => make(x, y, z))))
  ->flat
  ->flat
}

let rec rotateX = (point, angle) => {
  let {x, y, z} = point
  let at90 = {x: x, y: z, z: 0 - y}
  switch angle {
  | #0 => point
  | #90 => at90
  | #180 => rotateX(at90, #90)
  | #270 => rotateX(at90, #180)
  }
}

let rec rotateY = (point, angle) => {
  let {x, y, z} = point
  let at90 = {x: 0 - z, y: y, z: x}
  switch angle {
  | #0 => point
  | #90 => at90
  | #180 => rotateY(at90, #90)
  | #270 => rotateY(at90, #180)
  }
}

let rec rotateZ = (point, angle) => {
  let {x, y, z} = point
  let at90 = {x: y, y: 0 - x, z: z}
  switch angle {
  | #0 => point
  | #90 => at90
  | #180 => rotateZ(at90, #90)
  | #270 => rotateZ(at90, #180)
  }
}

let rotate = (point, (rotX, rotY, rotZ)) => point->rotateX(rotX)->rotateY(rotY)->rotateZ(rotZ)

let distance = (a, b) =>
  sqrt(
    abs(a.x - b.x)->int_to_float ** 2. +.
    abs(a.y - b.y)->int_to_float ** 2. +.
    abs(a.z - b.z)->int_to_float ** 2.,
  )

let manhattanDistance = (a, b) => abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)

let vector = (from, to_) => make(to_.x - from.x, to_.y - from.y, to_.z - from.z)
let translate = (p, v) => make(p.x + v.x, p.y + v.y, p.z + v.z)

let eq = (a, b) => a.x == b.x && a.y == b.y && a.z == b.z

let cmp = (a, b) =>
  switch a.x - b.x {
  | 0 =>
    switch a.y - b.y {
    | 0 => a.z - b.z
    | d => d
    }
  | c => c
  }

module Comparable = Belt.Id.MakeComparable({
  type t = t
  let cmp = cmp
})

let toString = p => `(${p.x->int_to_string}, ${p.y->int_to_string}, ${p.z->int_to_string})`
