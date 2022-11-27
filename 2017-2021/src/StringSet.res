open Js.String2

type t

let empty: t = Obj.magic("")

let toString = (set: t): string => Obj.magic(set)

let has = (set, value) => set->toString->charAt(value) === "#"

%%private(
  let replaceAt = (str, index, value) =>
    str->substring(~from=0, ~to_=index) ++ value ++ str->substringToEnd(~from=index + 1)
)

let add = (set, value) =>
  if set->has(value) {
    set
  } else {
    let str = toString(set)
    switch value - str->length {
    | x if x >= 0 => str ++ "."->repeat(x) ++ "#"
    | _ => str->replaceAt(value, "#")
    }->Obj.magic
  }

let remove = (set, value) => set->has(value) ? set->toString->replaceAt(value, ".")->Obj.magic : set

let toArray = set => {
  let result = []
  for i in 0 to set->toString->length - 1 {
    if set->has(i) {
      result->Js.Array2.push(i)->ignore
    }
  }
  result
}

let size = set => set->toArray->Js.Array2.length
