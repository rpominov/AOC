// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Tools = require("../Tools.bs.js");
var Caml_int32 = require("rescript/lib/js/caml_int32.js");
var Pervasives = require("rescript/lib/js/pervasives.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Belt_MutableMapInt = require("rescript/lib/js/belt_MutableMapInt.js");

function effectivePower(group) {
  return Math.imul(group.units, group.damage);
}

function damageToGroup(attacker, target) {
  if (target.immune.includes(attacker.attack)) {
    return 0;
  } else if (target.weak.includes(attacker.attack)) {
    return (effectivePower(attacker) << 1);
  } else {
    return effectivePower(attacker);
  }
}

function battle(groups) {
  var targets = Belt_MutableMapInt.make(undefined);
  groups.sort(function (a, b) {
        var x = effectivePower(b) - effectivePower(a) | 0;
        if (x !== 0) {
          return x;
        } else {
          return b.initiative - a.initiative | 0;
        }
      });
  for(var i = 0 ,i_finish = groups.length; i < i_finish; ++i){
    var attacker = groups[i];
    var potentialTargets = groups.filter((function(attacker){
          return function (group) {
            if (group.adherence !== attacker.adherence) {
              return Belt_MutableMapInt.every(targets, (function (param, target) {
                            return target !== group.initiative;
                          }));
            } else {
              return false;
            }
          }
          }(attacker))).map((function(attacker){
        return function (group) {
          return {
                  initiative: group.initiative,
                  damage: damageToGroup(attacker, group),
                  effectivePower: effectivePower(group)
                };
        }
        }(attacker)));
    if (potentialTargets.length > 0) {
      var target = potentialTargets.sort(function (a, b) {
              var x = b.damage - a.damage | 0;
              if (x !== 0) {
                return x;
              }
              var x$1 = b.effectivePower - a.effectivePower | 0;
              if (x$1 !== 0) {
                return x$1;
              } else {
                return b.initiative - a.initiative | 0;
              }
            })[0];
      Belt_MutableMapInt.set(targets, attacker.initiative, target.initiative);
    }
    
  }
  var updatedGroups = Belt_MutableMapInt.make(undefined);
  var latest = function (group) {
    var x = Belt_MutableMapInt.get(updatedGroups, group.initiative);
    if (x !== undefined) {
      return x;
    } else {
      return group;
    }
  };
  groups.sort(function (a, b) {
        return b.initiative - a.initiative | 0;
      });
  for(var i$1 = 0 ,i_finish$1 = groups.length; i$1 < i_finish$1; ++i$1){
    var attacker$1 = latest(groups[i$1]);
    var targetInitiative = Belt_MutableMapInt.get(targets, attacker$1.initiative);
    if (targetInitiative !== undefined && attacker$1.units > 0) {
      var target$1 = groups.find((function(targetInitiative){
          return function (x) {
            return x.initiative === targetInitiative;
          }
          }(targetInitiative)));
      var target$2 = target$1 === undefined ? undefined : Caml_option.some(target$1);
      var deaths = Caml_int32.div(damageToGroup(attacker$1, target$2), target$2.hp);
      Belt_MutableMapInt.set(updatedGroups, target$2.initiative, {
            adherence: target$2.adherence,
            units: target$2.units - deaths | 0,
            hp: target$2.hp,
            weak: target$2.weak,
            immune: target$2.immune,
            attack: target$2.attack,
            damage: target$2.damage,
            initiative: target$2.initiative
          });
    }
    
  }
  return groups.map(latest).filter(function (group) {
              return group.units > 0;
            });
}

function parseAttak(str) {
  switch (str) {
    case "bludgeoning" :
        return /* Bludgeoning */4;
    case "cold" :
        return /* Cold */2;
    case "fire" :
        return /* Fire */3;
    case "radiation" :
        return /* Radiation */1;
    case "slashing" :
        return /* Slashing */0;
    default:
      return Pervasives.failwith(str);
  }
}

function parseTraits(data, tag) {
  if (data === undefined) {
    return [];
  }
  var str$p = data.split("; ").find(function (__x) {
        return __x.startsWith(tag);
      });
  if (str$p !== undefined) {
    return Tools.exn(Tools.$$Array.get(str$p.split(" to "), 1)).split(", ").map(parseAttak);
  } else {
    return [];
  }
}

AoC.getInput("2018", "24", (function (input) {
        var groups = input.split("\n\n").map(function (text, i, param) {
                return Tools.lines(text).slice(1).map(function (line) {
                            var match = line.match(/^(\d+) units each with (\d+) hit points (?:\((.*)\) )?with an attack that does (\d+) (\S+) damage at initiative (\d+)$/);
                            if (match === null) {
                              return Pervasives.failwith(line);
                            }
                            if (match.length !== 7) {
                              return Pervasives.failwith(line);
                            }
                            var units = match[1];
                            var hp = match[2];
                            var traits = match[3];
                            var damage = match[4];
                            var attack = match[5];
                            var initiative = match[6];
                            return {
                                    adherence: i === 0 ? /* ImmuneSystem */0 : /* Infection */1,
                                    units: parseInt(units, 10),
                                    hp: parseInt(hp, 10),
                                    weak: parseTraits(traits, "weak"),
                                    immune: parseTraits(traits, "immune"),
                                    attack: parseAttak(attack),
                                    damage: parseInt(damage, 10),
                                    initiative: parseInt(initiative, 10)
                                  };
                          });
              }).flat();
        var countUnits = function (groups) {
          return Tools.reduce(groups.map(function (group) {
                          return group.units;
                        }), 0, (function (prim0, prim1) {
                        return prim0 + prim1 | 0;
                      }));
        };
        var battleUntil = function (_groups) {
          while(true) {
            var groups = _groups;
            if (!(groups.length > 0 && groups.some((function(groups){
                    return function (group) {
                      return group.adherence !== groups[0].adherence;
                    }
                    }(groups))))) {
              return groups;
            }
            var afterBattle = battle(groups);
            if (countUnits(groups) === countUnits(afterBattle)) {
              return ;
            }
            _groups = afterBattle;
            continue ;
          };
        };
        var __x = countUnits(Tools.exn(battleUntil(groups)));
        console.log("part 1:", __x);
        var boostImmuneSystem = function (groups, boost) {
          return groups.map(function (group) {
                      if (group.adherence === /* ImmuneSystem */0) {
                        return {
                                adherence: group.adherence,
                                units: group.units,
                                hp: group.hp,
                                weak: group.weak,
                                immune: group.immune,
                                attack: group.attack,
                                damage: group.damage + boost | 0,
                                initiative: group.initiative
                              };
                      } else {
                        return group;
                      }
                    });
        };
        var findMinimumBoost = function (_low, _high) {
          while(true) {
            var high = _high;
            var low = _low;
            if ((low + 1 | 0) === high) {
              return high;
            }
            var middle = ((high - low | 0) / 2 | 0) + low | 0;
            var result = battleUntil(boostImmuneSystem(groups, middle));
            if (result !== undefined && result.length > 0 && result[0].adherence === /* ImmuneSystem */0) {
              _high = middle;
              continue ;
            }
            _low = middle;
            continue ;
          };
        };
        var __x$1 = countUnits(Tools.exn(battleUntil(boostImmuneSystem(groups, findMinimumBoost(0, 10000)))));
        console.log("part 2:", __x$1);
        
      }));

var $$Map;

exports.$$Map = $$Map;
exports.effectivePower = effectivePower;
exports.damageToGroup = damageToGroup;
exports.battle = battle;
exports.parseAttak = parseAttak;
exports.parseTraits = parseTraits;
/*  Not a pure module */