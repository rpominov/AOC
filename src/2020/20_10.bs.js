// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Tools = require("../Tools.bs.js");
var Belt_MutableMapInt = require("rescript/lib/js/belt_MutableMapInt.js");

AoC.getInput("2020", "10", (function (input_) {
        var input = Tools.sort(Tools.filterMap(Tools.lines(input_), Tools.string_to_int), (function (a, b) {
                return a - b | 0;
              }));
        var diffs = input.map(function (v, i, a) {
              if (i === 0) {
                return v;
              } else {
                return v - a[i - 1 | 0] | 0;
              }
            });
        console.log("part 1:", Math.imul(Tools.count(diffs, (function (x) {
                        return x === 3;
                      })) + 1 | 0, Tools.count(diffs, (function (x) {
                        return x === 1;
                      }))));
        var mem = Belt_MutableMapInt.make(undefined);
        var ways = function (toGetTo) {
          if (toGetTo === 0) {
            return 1;
          }
          if (!input.includes(toGetTo)) {
            return 0;
          }
          var result = Belt_MutableMapInt.get(mem, toGetTo);
          if (result !== undefined) {
            return result;
          }
          var result$1 = ways(toGetTo - 1 | 0) + ways(toGetTo - 2 | 0) + ways(toGetTo - 3 | 0);
          Belt_MutableMapInt.set(mem, toGetTo, result$1);
          return result$1;
        };
        console.log("part 2:", ways(Tools.last(input)));
        
      }));

var $$Map;

exports.$$Map = $$Map;
/*  Not a pure module */
