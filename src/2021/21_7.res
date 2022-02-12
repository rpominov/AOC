open Tools

AoC.getInput("2021", "7", input_ => {
  let input = input_->split(",")->map(string_to_int_unsafe)

  let getFuel = align => {
    // input->reduce(0, (acc, x) => acc + abs_int(align - x))
    input->reduce(0, (acc, x) => {
      let diff = abs(align - x)
      acc + diff * (diff + 1) / 2
    })
  }

  let rec solve = guess => {
    let cur = getFuel(guess)
    getFuel(guess + 1) < cur ? solve(guess + 1) : cur
  }

  solve(0)->Js.log
})
