module S = Js.String2
module A = Js.Array2
module St = Belt.MutableSet.String

let key = ((x, y)) => S.make(x) ++ "," ++ S.make(y)

let moveTail = (head, tail) => {
  let relativeX = tail.contents->fst - head.contents->fst
  let relativeY = tail.contents->snd - head.contents->snd

  let (relativeX', relativeY') = switch (relativeX, relativeY) {
  | (-2, -2) => (-1, -1)
  | (-2, 2) => (-1, 1)
  | (2, -2) => (1, -1)
  | (2, 2) => (1, 1)
  | (_, -2) => (0, -1)
  | (_, 2) => (0, 1)
  | (-2, _) => (-1, 0)
  | (2, _) => (1, 0)
  | xy => xy
  }

  tail := (head.contents->fst + relativeX', head.contents->snd + relativeY')
}

let part1 = input => {
  let head = ref((0, 0))
  let tail = ref(head.contents)
  let visited = St.make()
  visited->St.add(key(tail.contents))

  let move = (fn, count) => {
    for _ in 0 to int_of_string(count) - 1 {
      head := fn(head.contents->fst, head.contents->snd)
      moveTail(head, tail)
      visited->St.add(key(tail.contents))
    }
  }

  input
  ->S.split("\n")
  ->A.forEach(line => {
    switch line->S.split(" ") {
    | ["U", n] => move((x, y) => (x, y + -1), n)
    | ["D", n] => move((x, y) => (x, y + 1), n)
    | ["L", n] => move((x, y) => (x + -1, y), n)
    | ["R", n] => move((x, y) => (x + 1, y), n)
    | _ => failwith("invalid input: " ++ line)
    }
  })

  visited->St.size
}

let part2 = input => {
  let head = ref((0, 0))
  let tail1 = ref(head.contents)
  let tail2 = ref(head.contents)
  let tail3 = ref(head.contents)
  let tail4 = ref(head.contents)
  let tail5 = ref(head.contents)
  let tail6 = ref(head.contents)
  let tail7 = ref(head.contents)
  let tail8 = ref(head.contents)
  let tail9 = ref(head.contents)

  let visited = St.make()
  visited->St.add(key(tail9.contents))

  let move = (fn, count) => {
    for _ in 0 to int_of_string(count) - 1 {
      head := fn(head.contents->fst, head.contents->snd)
      moveTail(head, tail1)
      moveTail(tail1, tail2)
      moveTail(tail2, tail3)
      moveTail(tail3, tail4)
      moveTail(tail4, tail5)
      moveTail(tail5, tail6)
      moveTail(tail6, tail7)
      moveTail(tail7, tail8)
      moveTail(tail8, tail9)
      visited->St.add(key(tail9.contents))
    }
  }

  input
  ->S.split("\n")
  ->A.forEach(line => {
    switch line->S.split(" ") {
    | ["U", n] => move((x, y) => (x, y + -1), n)
    | ["D", n] => move((x, y) => (x, y + 1), n)
    | ["L", n] => move((x, y) => (x + -1, y), n)
    | ["R", n] => move((x, y) => (x + 1, y), n)
    | _ => failwith("invalid input: " ++ line)
    }
  })

  visited->St.size
}
