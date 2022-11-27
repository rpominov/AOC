open Tools

let inside = (inner, outer) => inner->split("")->every(outer->string_includes)
let sameComb = (a, b) => a->string_length == b->string_length && a->inside(b)

AoC.getInput("2021", "8", input_ => {
  let input =
    input_->lines->map(line => line->split(" | ")->map(split(_, " "))->array_to_pair->unsafe)

  input->flatMap(snd)->map(string_length)->count(includes([2, 3, 4, 7]))->Js.log2("part 1:", _)

  input
  ->mapSum(((sample, out)) => {
    let one = sample->find(x => x->string_length == 2)->exn
    let four = sample->find(x => x->string_length == 4)->exn
    let seven = sample->find(x => x->string_length == 3)->exn
    let eight = sample->find(x => x->string_length == 7)->exn

    let six = sample->find(x => x->string_length == 6 && !inside(one, x))->exn
    let nine = sample->find(x => x->string_length == 6 && four->inside(x))->exn
    let zero = sample->find(x => x->string_length == 6 && x != nine && x != six)->exn

    let five = sample->find(x => x->string_length == 5 && x->inside(six))->exn
    let three = sample->find(x => x->string_length == 5 && one->inside(x))->exn
    let two = sample->find(x => x->string_length == 5 && x != three && x != five)->exn

    let mapping = [zero, one, two, three, four, five, six, seven, eight, nine]

    out
    ->map(x => mapping->findIndex(sameComb(x)))
    ->map(int_to_string)
    ->join("")
    ->string_to_int_unsafe
  })
  ->Js.log2("part 2:", _)
})
