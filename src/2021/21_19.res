open Tools

module Map = Belt.Map.String
module List = Belt.List

let angles = [#0, #90, #180, #270]

let canonicalRotations =
  angles
  ->flatMap(x => angles->flatMap(y => angles->map(z => (x, y, z))))
  ->reduce(Map.empty, (acc, rotation) =>
    acc->Map.set(
      [Point3d.make(0, 0, 1), Point3d.make(0, 1, 0), Point3d.make(1, 0, 0)]
      ->map(p => p->Point3d.rotate(rotation)->Point3d.toString)
      ->join(","),
      rotation,
    )
  )
  ->Map.valuesToArray

let rec findVectorHelper = (acc, existing, point) =>
  switch existing[0] {
  | None => Error(acc)
  | Some(ep) => {
      let vector = Point3d.vector(point, ep)
      let key = vector->Point3d.toString
      let count = acc->Map.getWithDefault(key, 0) + 1
      if count >= 12 {
        Ok(vector)
      } else {
        let acc' = acc->Map.set(key, count)
        let existing' = existing->rest
        findVectorHelper(acc', existing', point)
      }
    }
  }
let findTranslationVector = (existing, new, rotation) => {
  switch new->reduce(Error(Map.empty), (acc, point) =>
    switch acc {
    | Ok(vector) => Ok(vector)
    | Error(acc') => findVectorHelper(acc', existing, point->Point3d.rotate(rotation))
    }
  ) {
  | Ok(v) => Some(v)
  | _ => None
  }
}

let rec findRotationAndTranslation = (~rotations=canonicalRotations, existing, new) => {
  switch rotations[0] {
  | None => None
  | Some(r) =>
    switch findTranslationVector(existing, new, r) {
    | Some(t) => Some((r, t))
    | None => findRotationAndTranslation(~rotations=rotations->rest, existing, new)
    }
  }
}

let merge = (existing, new) => {
  switch findRotationAndTranslation(existing, new) {
  | Some((r, t)) => {
      let new' = new->filterMap(p => {
        let p' = p->Point3d.rotate(r)->Point3d.translate(t)
        existing->some(Point3d.eq(p')) ? None : Some(p')
      })
      Some((t, existing->concat(new')))
    }
  | None => None
  }
}

let rec mergeAll = (list, onMerged) => {
  switch list {
  | list{result} => Some(result)
  | list{f, s, ...rest} =>
    switch merge(f, s) {
    | Some((t, result)) => {
        onMerged(t)
        Js.log(`merged! ${rest->List.length->int_to_string} remainig`)
        mergeAll(list{result, ...rest}, onMerged)
      }
    // FIXME: this will get into an infinite loop if there's no solution
    | None => mergeAll(list{f, ...rest->List.concat(list{s})}, onMerged)
    }
  | list{} => None
  }
}

AoC.getInput("2021", "19", input_ => {
  let input =
    input_
    ->split("\n\n")
    ->map(x =>
      x
      ->lines
      ->rest
      ->filterMap(line => line->split(",")->map(string_to_int_unsafe)->Point3d.fromArray)
    )

  let translationVectors = [Point3d.make(0, 0, 0)]

  // part 1
  input->List.fromArray->mergeAll(v => translationVectors->push(v)->ignore)->exn->length->Js.log

  // part 2
  translationVectors
  ->flatMap(v => translationVectors->map(Point3d.manhattanDistance(v)))
  ->Js.Math.maxMany_int
  ->Js.log
})
