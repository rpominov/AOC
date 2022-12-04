module S = Js.String2
module A = Js.Array2
module O = Belt.Option

let part1 = input => {
  input
  ->S.trim
  ->S.split("\n")
  ->A.filter(line => {
    let split = line->S.splitByRe(%re("/[-,]/"))->A.map(O.getExn)
    switch split->A.map(int_of_string) {
    | [a, b, c, d] => (a <= c && b >= d) || (a >= c && b <= d)
    | _ => failwith("invalid input " ++ line)
    }
  })
  ->A.length
}

let part2 = input => {
  input
  ->S.trim
  ->S.split("\n")
  ->A.filter(line => {
    let split = line->S.splitByRe(%re("/[-,]/"))->A.map(O.getExn)
    switch split->A.map(int_of_string) {
    | [a, b, c, d] => (c <= b && d >= a) || (d >= a && c <= b)
    | _ => failwith("invalid input " ++ line)
    }
  })
  ->A.length
}
