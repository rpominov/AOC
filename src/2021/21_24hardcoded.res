open Tools

// let params = [
//   (1, 12., 6.),
//   (1, 10., 6.),
//   (1, 13., 3.),
//   (26, -11., 11.),
//   (1, 13., 9.),
//   (26, -1., 3.),
//   (1, 10., 13.),
//   (1, 11., 6.),
//   (26, 0., 14.),
//   (1, 10., 10.),
//   (26, -5., 12.),
//   (26, -16., 10.),
//   (26, -7., 11.),
//   (26, -11., 15.),
// ]

let f1 = (p2, p3, z, i) => {
  let i' = i->int_to_float

  mod_float(z, 26.) +. p2 === i' ? z : i' +. p3 +. z *. 26.
}

let f26 = (p2, p3, z, i) => {
  let i' = i->int_to_float

  let z' = Js.Math.trunc(z /. 26.)
  let mod = z -. z'
  mod +. p2 === i' ? z' : i' +. p3 +. z' *. 26.
}

// 83892666666666 - too low!

let z = 0.
for x1 in 9 downto 1 {
  let z = f1(12., 6., z, x1)
  for x2 in 9 downto 1 {
    let z = f1(10., 6., z, x2)
    for x3 in 9 downto 1 {
      let z = f1(13., 3., z, x3)
      for x4 in 9 downto 1 {
        let z = f26(-11., 11., z, x4)
        for x5 in 9 downto 1 {
          let z = f1(13., 9., z, x5)
          Js.log(j`$x1$x2$x3$x4$x5`)
          for x6 in 9 downto 1 {
            let z = f26(-1., 3., z, x6)
            for x7 in 9 downto 1 {
              let z = f1(10., 13., z, x7)
              for x8 in 9 downto 1 {
                let z = f1(11., 6., z, x8)
                for x9 in 9 downto 1 {
                  let z = f26(0., 14., z, x9)
                  for x10 in 9 downto 1 {
                    let z = f1(10., 10., z, x10)
                    for x11 in 9 downto 1 {
                      let z = f26(-5., 12., z, x11)
                      for x12 in 9 downto 1 {
                        let z = f26(-16., 10., z, x12)
                        for x13 in 9 downto 1 {
                          let z = f26(-7., 11., z, x13)
                          for x14 in 9 downto 1 {
                            let z = f26(-11., 15., z, x14)
                            if z === 0. {
                              failwith(
                                [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14]
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
