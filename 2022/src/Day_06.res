module S = Js.String2
module A = Js.Array2
module St = Belt.Set.String

let part1 = input => {
  let last4 = []
  let i = ref(0)
  while St.fromArray(last4)->St.size < 4 {
    let char = S.charAt(input, i.contents)
    last4->A.push(char)->ignore
    if last4->A.length > 4 {
      last4->A.shift->ignore
    }
    i := i.contents + 1
  }
  i.contents
}

let part2 = input => {
  let last14 = []
  let i = ref(0)
  while St.fromArray(last14)->St.size < 14 {
    let char = S.charAt(input, i.contents)
    last14->A.push(char)->ignore
    if last14->A.length > 14 {
      last14->A.shift->ignore
    }
    i := i.contents + 1
  }
  i.contents
}
