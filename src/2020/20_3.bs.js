// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Tools = require("../Tools.bs.js");
var Caml_int32 = require("rescript/lib/js/caml_int32.js");

function atCoords(grid, x, y) {
  var row = grid[y];
  return row[Caml_int32.mod_(x, row.length)];
}

AoC.getInput("2020", "3", (function (input_) {
        var grid = Tools.lines(input_).map(function (__x) {
              return __x.split("");
            });
        var treesAtSlope = function (slope) {
          return Tools.count(Tools.range(0, Caml_int32.div(grid.length, slope.down) - 1 | 0), (function (step) {
                        return atCoords(grid, Math.imul(step, slope.right), Math.imul(step, slope.down)) === "#";
                      }));
        };
        var __x = treesAtSlope({
              down: 1,
              right: 3
            });
        console.log("part 1:", __x);
        var __x$1 = Tools.reduce([
                [
                  1,
                  1
                ],
                [
                  3,
                  1
                ],
                [
                  5,
                  1
                ],
                [
                  7,
                  1
                ],
                [
                  1,
                  2
                ]
              ].map(function (param) {
                  return treesAtSlope({
                              down: param[1],
                              right: param[0]
                            });
                }), 1, (function (prim0, prim1) {
                return prim0 * prim1;
              }));
        console.log("part 2:", __x$1);
        
      }));

exports.atCoords = atCoords;
/*  Not a pure module */
