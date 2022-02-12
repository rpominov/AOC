open Tools

type reg = X | Y | Z | W
type arg = Reg(reg) | Lit(float)
type op = Inp(reg) | Mul(reg, arg) | Add(reg, arg) | Div(reg, arg) | Mod(reg, arg) | Eql(reg, arg)

let strToReg = s =>
  switch s {
  | "x" => Some(X)
  | "y" => Some(Y)
  | "z" => Some(Z)
  | "w" => Some(W)
  | _ => None
  }

let strToRegExn = s =>
  switch strToReg(s) {
  | Some(x) => x
  | None => failwith(`not a reg: ${s}`)
  }

let strToArg = s =>
  switch strToReg(s) {
  | Some(r) => Reg(r)
  | None =>
    switch string_to_float(s) {
    | Some(n) => Lit(n)
    | None => failwith(`not an arg: ${s}`)
    }
  }

type memory = {x: float, y: float, z: float, w: float}

let write = (mem, reg, v) =>
  switch reg {
  | X => {...mem, x: v}
  | Y => {...mem, y: v}
  | Z => {...mem, z: v}
  | W => {...mem, w: v}
  }

let read = (mem, arg) =>
  switch arg {
  | Reg(X) => mem.x
  | Reg(Y) => mem.y
  | Reg(Z) => mem.z
  | Reg(W) => mem.w
  | Lit(x) => x
  }

let rec run = (~debug=false, prog, mem, input) => {
  if debug {
    Js.log(mem)
    Js.log(prog[0])
  }
  switch prog[0] {
  | None => (mem, prog)
  | Some(Inp(r)) =>
    switch input {
    | Some(i) => run(~debug, prog->rest, mem->write(r, i), None)
    | None => (mem, prog)
    }
  | Some(Add(r, a)) =>
    run(~debug, prog->rest, mem->write(r, mem->read(Reg(r)) +. mem->read(a)), input)
  | Some(Mul(r, a)) =>
    run(~debug, prog->rest, mem->write(r, mem->read(Reg(r)) *. mem->read(a)), input)
  | Some(Div(r, a)) =>
    run(~debug, prog->rest, mem->write(r, Js.Math.trunc(mem->read(Reg(r)) /. mem->read(a))), input)
  | Some(Mod(r, a)) =>
    run(~debug, prog->rest, mem->write(r, mem->read(Reg(r))->mod_float(mem->read(a))), input)
  | Some(Eql(r, a)) =>
    run(~debug, prog->rest, mem->write(r, mem->read(Reg(r)) === mem->read(a) ? 1. : 0.), input)
  }
}

AoC.getInput("2021", "24", input_ => {
  let monadProgram =
    input_
    ->lines
    ->map(line =>
      switch line->split(" ") {
      | ["inp", a] => Inp(a->strToRegExn)
      | ["mul", a, b] => Mul(a->strToRegExn, b->strToArg)
      | ["add", a, b] => Add(a->strToRegExn, b->strToArg)
      | ["div", a, b] => Div(a->strToRegExn, b->strToArg)
      | ["mod", a, b] => Mod(a->strToRegExn, b->strToArg)
      | ["eql", a, b] => Eql(a->strToRegExn, b->strToArg)
      | _ => failwith(`bad line: ${line}`)
      }
    )

  // 98765999999999 - incorrect
  // 99999999999999 - incorrect
  // 98464000000000 - too low!
  // 83892666666666 - too low!

  let (mem, prog) = ({x: 0., y: 0., z: 0., w: 0.}, monadProgram)
  for x1 in 9 downto 1 {
    let (mem, prog) = run(prog, mem, Some(x1->int_to_float))
    // Js.log2("1", mem)
    for x2 in 9 downto 1 {
      let (mem, prog) = run(prog, mem, Some(x2->int_to_float))
      // Js.log2("2", mem)
      for x3 in 9 downto 1 {
        let (mem, prog) = run(prog, mem, Some(x3->int_to_float))
        // Js.log2("3", mem)
        for x4 in 9 downto 1 {
          let (mem, prog) = run(prog, mem, Some(x4->int_to_float))
          // Js.log2("4", mem)
          for x5 in 9 downto 1 {
            Js.log(j`$x1$x2$x3$x4$x5`)
            let (mem, prog) = run(prog, mem, Some(x5->int_to_float))
            // Js.log2("5", mem)
            for x6 in 9 downto 1 {
              let (mem, prog) = run(prog, mem, Some(x6->int_to_float))
              // Js.log2("6", mem)
              for x7 in 9 downto 1 {
                let (mem, prog) = run(prog, mem, Some(x7->int_to_float))
                // Js.log2("7", mem)
                for x8 in 9 downto 1 {
                  let (mem, prog) = run(prog, mem, Some(x8->int_to_float))
                  // Js.log2("8", mem)
                  for x9 in 9 downto 1 {
                    let (mem, prog) = run(prog, mem, Some(x9->int_to_float))
                    // Js.log2("9", mem)
                    for x10 in 9 downto 1 {
                      let (mem, prog) = run(prog, mem, Some(x10->int_to_float))
                      // Js.log2("10", mem)
                      if mem.z < 26. *. 26. *. 26. *. 26. {
                        for x11 in 9 downto 1 {
                          let (mem, prog) = run(prog, mem, Some(x11->int_to_float))
                          // Js.log2("11", mem)
                          if mem.z < 26. *. 26. *. 26. {
                            for x12 in 9 downto 1 {
                              let (mem, prog) = run(prog, mem, Some(x12->int_to_float))
                              // Js.log2("12", mem)
                              if mem.z < 26. *. 26. {
                                for x13 in 9 downto 1 {
                                  let (mem, prog) = run(prog, mem, Some(x13->int_to_float))
                                  // Js.log2("13", mem)

                                  // for z in 0 to 25 {
                                  //   for i in 1 to 9 {

                                  //   }
                                  // }

                                  // let (mem, prog) = run(
                                  //   prog,
                                  //   {x: 0., y: 0., z: 12., w: 0.},
                                  //   Some(1.),
                                  //   ~debug=true,
                                  // )
                                  //  Js.log(mem)

                                  // failwith("tmp")

                                  if mem.z < 26. {
                                    for x14 in 9 downto 1 {
                                      let (mem, _) = run(prog, mem, Some(x14->int_to_float))
                                      // Js.log2("14", mem)

                                      if mem.z === 0. {
                                        failwith(
                                          [
                                            x1,
                                            x2,
                                            x3,
                                            x4,
                                            x5,
                                            x6,
                                            x7,
                                            x8,
                                            x9,
                                            x10,
                                            x11,
                                            x12,
                                            x13,
                                            x14,
                                          ]
                                          ->map(int_to_string)
                                          ->join(""),
                                        )
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
})
