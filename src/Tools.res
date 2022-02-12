// array

external unsafe_at: (array<'a>, int) => 'a = "%array_unsafe_get"

@get
external length: array<'a> => int = "length"

// defines what [] does
module Array = {
  let get = (arr, i) => i >= 0 && i < arr->length ? Some(arr->unsafe_at(i)) : None
}

@send
external push: (array<'a>, 'a) => int = "push"

@send
external map: (array<'a>, @uncurry ('a => 'b)) => array<'b> = "map"
@send
external mapi: (array<'a>, @uncurry ('a, int, array<'a>) => 'b) => array<'b> = "map"

@send
external flat: array<array<'a>> => array<'a> = "flat"
@send
external flat2: (array<array<array<'a>>>, @as(2) _) => array<'a> = "flat"
@send
external flat3: (array<array<array<array<'a>>>>, @as(3) _) => array<'a> = "flat"
@send
external flatMap: (array<'a>, @uncurry ('a => array<'b>)) => array<'b> = "flatMap"
@send
external flatMapi: (array<'a>, @uncurry ('a, int, array<'a>) => array<'b>) => array<'b> = "flatMap"
let filterMap = Belt.Array.keepMap

@send
external concat: (array<'a>, array<'a>) => array<'a> = "concat"

@send
external slice: (array<'a>, int, int) => array<'a> = "slice"
@send
external sliceFrom: (array<'a>, int) => array<'a> = "slice"

@send
external filter: (array<'a>, @uncurry ('a => bool)) => array<'a> = "filter"
@send
external filteri: (array<'a>, @uncurry ('a, int, array<'a>) => bool) => array<'a> = "filter"

@send @return(undefined_to_opt)
external find: (array<'a>, @uncurry ('a => bool)) => option<'a> = "find"
@send @return(undefined_to_opt)
external findi: (array<'a>, @uncurry ('a, int, array<'a>) => bool) => option<'a> = "find"

@send
external findIndex: (array<'a>, @uncurry ('a => bool)) => int = "findIndex"
@send
external findIndexi: (array<'a>, @uncurry ('a, int, array<'a>) => bool) => int = "findIndex"

@send
external every: (array<'a>, @uncurry ('a => bool)) => bool = "every"
@send
external everyi: (array<'a>, @uncurry ('a, int, array<'a>) => bool) => bool = "every"

@send
external some: (array<'a>, @uncurry ('a => bool)) => bool = "some"
@send
external somei: (array<'a>, @uncurry ('a, int, array<'a>) => bool) => bool = "some"

@send
external includes: (array<'a>, 'a) => bool = "includes"

let last = arr =>
  switch arr->length {
  | 0 => None
  | l => Some(arr->unsafe_at(l - 1))
  }

let rest = arr => arr->sliceFrom(1)

@send
external sortInPlace: (array<'a>, @uncurry ('a, 'a) => int) => array<'a> = "sort"
let sort = Belt.SortArray.stableSortBy

let range = Belt.Array.range
let reduce = Belt.Array.reduce
let reducei = Belt.Array.reduceWithIndex

let array_to_pair = (arr: array<'a>): option<('a, 'a)> =>
  switch arr->length {
  | 0 | 1 => None
  | 2 => Some(Obj.magic(arr))
  | _ => Some((arr->unsafe_at(0), arr->unsafe_at(1)))
  }
external pair_to_array: (('a, 'a)) => array<'a> = "%identity"

let rec findMap = (startAt, length, arr, f) => {
  if startAt === length {
    None
  } else {
    switch f(arr->unsafe_at(startAt)) {
    | None => findMap(startAt + 1, length, arr, f)
    | some => some
    }
  }
}
let findMap = (arr, f) => findMap(0, arr->length, arr, f)

let count = (arr, f) => arr->filter(f)->length
let mapSum = (arr, f) => arr->reduce(0, (acc, x) => acc + f(x))

let mapiPreserveRef = (arr, f) => {
  let changed = ref(false)
  let result = arr->mapi((x, i, _) => {
    let x' = f(x, i)
    if x !== x' {
      changed := true
    }
    x'
  })
  changed.contents ? result : arr
}

// int

@scope("Math") @val @variadic
external maxMany: array<int> => int = "max"
@scope("Math") @val @variadic
external minMany: array<int> => int = "min"

// float

@scope("Math") @val @variadic
external maxMany_float: array<float> => float = "max"
@scope("Math") @val @variadic
external minMany_float: array<float> => float = "min"

// string

@get
external string_length: string => int = "length"

@send
external join: (array<string>, string) => string = "join"

@send
external trim: string => string = "trim"

@send
external string_slice: (string, int, int) => string = "slice"

@send
external string_sliceFrom: (string, int) => string = "slice"

@send
external string_includes: (string, string) => bool = "includes"

@send
external startsWith: (string, string) => bool = "startsWith"

@send
external split: (string, string) => array<string> = "split"
@send
external splitr: (string, Js.Re.t) => array<string> = "split" // unsafe for RegExps with capture

@send @return(null_to_opt)
external match_re: (string, Js.Re.t) => option<array<string>> = "match"

@send @return(null_to_opt)
external match_re_optional: (string, Js.Re.t) => option<array<option<string>>> = "match"

@get_index
external str_at: (string, int) => string = ""

let lines = input => input->split("\n")->filter(x => x != "")

// string <-> float <-> int
//   ^-------------------^

external float_to_int: float => int = "%intoffloat"
external int_to_float: int => float = "%identity"

@val external float_to_string: float => string = "String"
let string_to_float = Belt.Float.fromString

%%private(@val external isNaN: float => bool = "isNaN")
@send
external int_to_string: int => string = "toString"
external int_to_string_radix: (int, int) => string = "toString"
@val
external string_to_int: (string, int) => float = "parseInt"
let string_to_int_radix = (str, radix) => {
  switch string_to_int(str, radix) {
  | x if isNaN(x) => None
  | x => Some(x->float_to_int)
  }
}
let string_to_int = string_to_int_radix(_, 10)
@val
external string_to_int_unsafe: (string, @as(10) _) => int = "parseInt"

// option

external unsafe: option<'a> => 'a = "%identity"
let exn = Belt.Option.getExn
let map_option = Belt.Option.map
let flatMap_option = Belt.Option.flatMap

// range

let rec rangeSum = (acc, min, max, f) => {
  let acc' = acc + f(min)
  if min === max {
    acc'
  } else {
    rangeSum(acc', min + 1, max, f)
  }
}
let rangeSum = rangeSum(0)
