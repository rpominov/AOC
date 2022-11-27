open Tools

type direction = N | E | S | W

let rec rotate = (d, angle) => {
  if angle === 0 {
    d
  } else {
    switch d {
    | N => E
    | E => S
    | S => W
    | W => N
    }->rotate(angle - 90)
  }
}

let rec rotatePoint = (angle, x, y) => {
  angle === 0 ? (x, y) : rotatePoint(angle - 90, y, 0 - x)
}

let rec go1 = (i, instructions, direction, x, y) => {
  if i >= instructions->length {
    abs(x) + abs(y)
  } else {
    let instruction = instructions->unsafe_at(i)->string_slice(0, 1)
    let argument = instructions->unsafe_at(i)->string_sliceFrom(1)->string_to_int_unsafe
    switch instruction {
    | "N" => go1(i + 1, instructions, direction, x, y + argument)
    | "S" => go1(i + 1, instructions, direction, x, y - argument)
    | "E" => go1(i + 1, instructions, direction, x + argument, y)
    | "W" => go1(i + 1, instructions, direction, x - argument, y)
    | "R" => go1(i + 1, instructions, direction->rotate(argument), x, y)
    | "L" => go1(i + 1, instructions, direction->rotate(360 - argument), x, y)
    | "F" =>
      switch direction {
      | N => go1(i + 1, instructions, direction, x, y + argument)
      | S => go1(i + 1, instructions, direction, x, y - argument)
      | E => go1(i + 1, instructions, direction, x + argument, y)
      | W => go1(i + 1, instructions, direction, x - argument, y)
      }
    | _ => failwith(instruction)
    }
  }
}

let rec go2 = (i, instructions, wpX, wpY, x, y) => {
  if i >= instructions->length {
    abs(x) + abs(y)
  } else {
    let instruction = instructions->unsafe_at(i)->string_slice(0, 1)
    let argument = instructions->unsafe_at(i)->string_sliceFrom(1)->string_to_int_unsafe
    switch instruction {
    | "N" => go2(i + 1, instructions, wpX, wpY + argument, x, y)
    | "S" => go2(i + 1, instructions, wpX, wpY - argument, x, y)
    | "E" => go2(i + 1, instructions, wpX + argument, wpY, x, y)
    | "W" => go2(i + 1, instructions, wpX - argument, wpY, x, y)
    | "R" => {
        let (wpX', wpY') = rotatePoint(argument, wpX, wpY)
        go2(i + 1, instructions, wpX', wpY', x, y)
      }
    | "L" => {
        let (wpX', wpY') = rotatePoint(360 - argument, wpX, wpY)
        go2(i + 1, instructions, wpX', wpY', x, y)
      }
    | "F" => go2(i + 1, instructions, wpX, wpY, x + wpX * argument, y + wpY * argument)
    | _ => failwith(instruction)
    }
  }
}

AoC.getInput("2020", "12", input => {
  input->lines->go1(0, _, E, 0, 0)->Js.log2("part 1:", _)
  input->lines->go2(0, _, 10, 1, 0, 0)->Js.log2("part 2:", _)
})
