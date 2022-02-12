// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Tools = require("../Tools.bs.js");
var Pervasives = require("rescript/lib/js/pervasives.js");
var Belt_MutableSetInt = require("rescript/lib/js/belt_MutableSetInt.js");

function adjacentSum(arr, i) {
  var m = i % 5;
  return (((
              m === 0 ? 0 : arr[i - 1 | 0]
            ) + (
              i < 5 ? 0 : arr[i - 5 | 0]
            ) | 0) + (
            m === 4 ? 0 : arr[i + 1 | 0]
          ) | 0) + (
          i >= 20 ? 0 : arr[i + 5 | 0]
        ) | 0;
}

function step(__x) {
  return __x.map(function (v, i, arr) {
              var match = adjacentSum(arr, i);
              if (match !== 1 && (match !== 2 || v !== 0)) {
                return 0;
              } else {
                return 1;
              }
            });
}

function rating(arr) {
  return Tools.string_to_int_radix(arr.reverse().map(function (prim) {
                    return prim.toString();
                  }).join(""), 2);
}

AoC.getInput("2019", "24", (function (input) {
        var initialState = Tools.lines(input).flatMap(function (line) {
              return line.split("").map(function (x) {
                          switch (x) {
                            case "#" :
                                return 1;
                            case "." :
                                return 0;
                            default:
                              return Pervasives.failwith(x);
                          }
                        });
            });
        var seenStates = Belt_MutableSetInt.make(undefined);
        var findRepeat = function (_state) {
          while(true) {
            var state = _state;
            var r = rating(state);
            if (Belt_MutableSetInt.has(seenStates, r)) {
              return r;
            }
            Belt_MutableSetInt.add(seenStates, r);
            _state = step(state);
            continue ;
          };
        };
        var __x = findRepeat(initialState);
        console.log("part 1:", __x);
        
      }));

var $$Set;

var width = 5;

var height = 5;

exports.$$Set = $$Set;
exports.width = width;
exports.height = height;
exports.adjacentSum = adjacentSum;
exports.step = step;
exports.rating = rating;
/*  Not a pure module */