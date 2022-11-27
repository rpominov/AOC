open Tools

type rec tree<'a> = Leaf('a) | Node(tree<'a>, tree<'a>)
let rec mapTree = (~depth=0, tree, f, g) =>
  switch tree {
  | Leaf(x) => f(depth, x)
  | Node(a, b) => g(depth, mapTree(a, f, g, ~depth=depth + 1), mapTree(b, f, g, ~depth=depth + 1))
  }
let rec mapLeftMost = (tree, f) => {
  switch tree {
  | Leaf(x) => Leaf(f(x))
  | Node(l, r) => Node(mapLeftMost(l, f), r)
  }
}
let rec mapRightMost = (tree, f) => {
  switch tree {
  | Leaf(x) => Leaf(f(x))
  | Node(l, r) => Node(l, mapRightMost(r, f))
  }
}

// just for fun. simple version above works better here
//
// let rec addResult = (results, result, g) => {
//   switch (results, result) {
//   | (list{(dl, l), ...rest}, (dr, r)) if dl == dr => rest->addResult((dr - 1, g(dr - 1, l, r)), g)
//   | _ => list{result, ...results}
//   }
// }
// let rec mapTreeTailRec = (results, jobs, f, g) => {
//   switch jobs {
//   | list{} =>
//     switch results {
//     | list{(_, a)} => a
//     | _ => failwith("Should never happen")
//     }
//   | list{job, ...jobsRest} =>
//     switch job {
//     | (jobDepth, Leaf(x)) =>
//       mapTreeTailRec(results->addResult((jobDepth, f(jobDepth, x)), g), jobsRest, f, g)
//     | (jobDepth, Node(l, r)) =>
//       mapTreeTailRec(results, list{(jobDepth + 1, l), (jobDepth + 1, r), ...jobsRest}, f, g)
//     }
//   }
// }
// let mapTree = (tree, f, g) => mapTreeTailRec(list{}, list{(0, tree)}, f, g)

type sfNumber = tree<int>
let toString = number => number->mapTree((_, x) => x->int_to_string, (_, l, r) => `[${l},${r}]`)
let magnitude = number => number->mapTree((_, x) => x, (_, l, r) => l * 3 + r * 2)

type intermediate =
  | Exploded({mod: sfNumber, orig: sfNumber, l: option<int>, r: option<int>})
  | Reg(sfNumber)
let explode = number =>
  switch number->mapTree(
    (_, x) => {
      Reg(Leaf(x))
    },
    (d, l, r) => {
      switch (l, r) {
      | (Reg(Leaf(l')), Reg(Leaf(r'))) if d >= 4 =>
        Exploded({mod: Leaf(0), orig: Node(Leaf(l'), Leaf(r')), l: Some(l'), r: Some(r')})
      | (Reg(l'), Reg(r')) => Reg(Node(l', r'))
      | (Exploded(meta), Reg(r')) | (Exploded(meta), Exploded({orig: r'})) => {
          let orig' = Node(meta.orig, r')
          switch meta.r {
          | None => Exploded({...meta, orig: orig', mod: Node(meta.mod, r')})
          | Some(x) =>
            Exploded({
              ...meta,
              r: None,
              orig: orig',
              mod: Node(meta.mod, mapLeftMost(r', v => v + x)),
            })
          }
        }
      | (Reg(l'), Exploded(meta)) => {
          let orig' = Node(l', meta.orig)
          switch meta.l {
          | None => Exploded({...meta, orig: orig', mod: Node(l', meta.mod)})
          | Some(x) =>
            Exploded({
              ...meta,
              l: None,
              orig: orig',
              mod: Node(mapRightMost(l', v => v + x), meta.mod),
            })
          }
        }
      }
    },
  ) {
  | Reg(_) => None
  | Exploded({mod}) => Some(mod)
  }

type intermediate1 = Split({mod: sfNumber, orig: sfNumber}) | Reg(sfNumber)
let splitNumber = number => {
  switch number->mapTree(
    (_, x) => {
      x > 9
        ? Split({
            mod: Node(
              Leaf(Js.Math.floor_float(x->int_to_float /. 2.)->float_to_int),
              Leaf(Js.Math.ceil_float(x->int_to_float /. 2.)->float_to_int),
            ),
            orig: Leaf(x),
          })
        : Reg(Leaf(x))
    },
    (_, l, r) => {
      switch (l, r) {
      | (Reg(l'), Reg(r')) => Reg(Node(l', r'))
      | (Split({mod, orig}), Reg(r')) | (Split({mod, orig}), Split({orig: r'})) =>
        Split({mod: Node(mod, r'), orig: Node(orig, r')})
      | (Reg(l'), Split({mod, orig})) => Split({mod: Node(l', mod), orig: Node(l', orig)})
      }
    },
  ) {
  | Reg(_) => None
  | Split({mod}) => Some(mod)
  }
}

let rec reduceNumber = number => {
  switch number->explode {
  | Some(number') => reduceNumber(number')
  | None =>
    switch number->splitNumber {
    | Some(number') => reduceNumber(number')
    | None => number
    }
  }
}

let rec parse = json =>
  switch Js.Json.classify(json) {
  | Js.Json.JSONNumber(n) => Leaf(n->float_to_int)
  | Js.Json.JSONArray([a, b]) => Node(parse(a), parse(b))
  | _ => failwith(`Not a Snailfish Number: ${json->Js.Json.stringify}`)
  }

AoC.getInput("2021", "18", input_ => {
  let input = input_->lines->map(line => line->Js.Json.parseExn->parse)

  // part 1
  input->rest->reduce(input[0]->exn, (a, b) => Node(a, b)->reduceNumber)->magnitude->Js.log

  // part 2
  input
  ->map(x => input->filterMap(y => y == x ? None : Some(Node(x, y)->reduceNumber->magnitude)))
  ->flat
  ->Js.Math.maxMany_int
  ->Js.log
})

// Another solution idea:
//
// A tree can be represented as [ (depth1,value1), (depth2,value2), ... ]
// For examle ((1,2),((3,4),5)) becomes [(1,1), (1,2), (2,3), (2,4), (1,5)]
// There's enough information to assemble the tree there,
// and finding "first regular number to the left" etc. would be easy.
