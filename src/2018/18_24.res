open Tools
module Map = Belt.MutableMap.Int

type attack = Slashing | Radiation | Cold | Fire | Bludgeoning
type adherence = ImmuneSystem | Infection

type group = {
  adherence: adherence,
  units: int,
  hp: int,
  weak: array<attack>,
  immune: array<attack>,
  attack: attack,
  damage: int,
  initiative: int,
}

let effectivePower = group => group.units * group.damage

let damageToGroup = (attacker, target) =>
  target.immune->includes(attacker.attack)
    ? 0
    : target.weak->includes(attacker.attack)
    ? attacker->effectivePower * 2
    : attacker->effectivePower

type target = {
  initiative: int,
  damage: int,
  effectivePower: int,
}

let battle = groups => {
  let targets = Map.make()

  groups
  ->sortInPlace((a, b) =>
    switch b->effectivePower - a->effectivePower {
    | 0 => b.initiative - a.initiative
    | x => x
    }
  )
  ->ignore

  for i in 0 to groups->length - 1 {
    let attacker = groups->unsafe_at(i)
    let potentialTargets =
      groups
      ->filter(group =>
        group.adherence !== attacker.adherence &&
          targets->Map.every((_, target) => target !== group.initiative)
      )
      ->map(group => {
        initiative: group.initiative,
        effectivePower: group->effectivePower,
        damage: damageToGroup(attacker, group),
      })
    if potentialTargets->length > 0 {
      let target =
        potentialTargets
        ->sortInPlace((a, b) =>
          switch b.damage - a.damage {
          | 0 =>
            switch b.effectivePower - a.effectivePower {
            | 0 => b.initiative - a.initiative
            | x => x
            }
          | x => x
          }
        )
        ->unsafe_at(0)
      targets->Map.set(attacker.initiative, target.initiative)
    }
  }

  let updatedGroups = Map.make()

  let latest = (group: group) =>
    switch updatedGroups->Map.get(group.initiative) {
    | Some(x) => x
    | None => group
    }

  groups->sortInPlace((a, b) => b.initiative - a.initiative)->ignore

  for i in 0 to groups->length - 1 {
    let attacker = latest(groups->unsafe_at(i))
    switch targets->Map.get(attacker.initiative) {
    | Some(targetInitiative) if attacker.units > 0 => {
        let target = groups->find(x => x.initiative === targetInitiative)->unsafe
        let deaths = attacker->damageToGroup(target) / target.hp
        updatedGroups->Map.set(target.initiative, {...target, units: target.units - deaths})
      }
    | _ => ()
    }
  }

  groups->map(latest)->filter(group => group.units > 0)
}

let parseAttak = str =>
  switch str {
  | "slashing" => Slashing
  | "radiation" => Radiation
  | "cold" => Cold
  | "fire" => Fire
  | "bludgeoning" => Bludgeoning
  | _ => failwith(str)
  }

let parseTraits = (data, tag) =>
  switch data {
  | None => []
  | Some(str) =>
    switch str->split("; ")->find(startsWith(_, tag)) {
    | None => []
    | Some(str') => (str'->split(" to "))[1]->exn->split(", ")->map(parseAttak)
    }
  }

AoC.getInput("2018", "24", input => {
  let groups =
    input
    ->split("\n\n")
    ->mapi((text, i, _) =>
      text
      ->lines
      ->sliceFrom(1)
      ->map(line =>
        switch line->match_re_optional(
          %re(
            "/^(\d+) units each with (\d+) hit points (?:\((.*)\) )?with an attack that does (\d+) (\S+) damage at initiative (\d+)$/"
          ),
        ) {
        | Some([_, units, hp, traits, damage, attack, initiative]) => {
            adherence: i === 0 ? ImmuneSystem : Infection,
            units: units->unsafe->string_to_int_unsafe,
            hp: hp->unsafe->string_to_int_unsafe,
            weak: traits->parseTraits("weak"),
            immune: traits->parseTraits("immune"),
            attack: attack->unsafe->parseAttak,
            damage: damage->unsafe->string_to_int_unsafe,
            initiative: initiative->unsafe->string_to_int_unsafe,
          }
        | _ => failwith(line)
        }
      )
    )
    ->flat

  let countUnits = groups => groups->map(group => group.units)->reduce(0, \"+")

  let rec battleUntil = groups => {
    if (
      groups->length > 0 &&
        groups->some(group => group.adherence !== (groups->unsafe_at(0)).adherence)
    ) {
      let afterBattle = groups->battle
      if groups->countUnits !== afterBattle->countUnits {
        afterBattle->battleUntil
      } else {
        None
      }
    } else {
      groups->Some
    }
  }

  groups->battleUntil->exn->countUnits->Js.log2("part 1:", _)

  let boostImmuneSystem = (groups, boost) =>
    groups->map(group =>
      group.adherence === ImmuneSystem ? {...group, damage: group.damage + boost} : group
    )

  let rec findMinimumBoost = (low, high) => {
    if low + 1 === high {
      high
    } else {
      let middle = (high - low) / 2 + low
      let result = groups->boostImmuneSystem(middle)->battleUntil
      if (
        result !== None &&
        result->unsafe->length > 0 &&
        (result->unsafe->unsafe_at(0)).adherence === ImmuneSystem
      ) {
        findMinimumBoost(low, middle)
      } else {
        findMinimumBoost(middle, high)
      }
    }
  }

  groups
  ->boostImmuneSystem(findMinimumBoost(0, 10000))
  ->battleUntil
  ->exn
  ->countUnits
  ->Js.log2("part 2:", _)
})
