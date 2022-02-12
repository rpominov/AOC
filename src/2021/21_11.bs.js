// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Tools = require("../Tools.bs.js");

function slice3(arr, middle) {
  return arr.slice(Math.max(0, middle - 1 | 0), middle + 2 | 0);
}

function charged(x) {
  return x > 9;
}

function flash(_grid) {
  while(true) {
    var grid = _grid;
    var grid$p = grid.map((function(grid){
        return function (line, i, param) {
          return line.map(function (el, j, param) {
                      if (el !== 0 && el <= 9) {
                        return el + slice3(grid, i).map(function (__x) {
                                        return slice3(__x, j);
                                      }).flat().filter(charged).length | 0;
                      } else {
                        return 0;
                      }
                    });
        }
        }(grid)));
    if (!grid$p.flat().some(charged)) {
      return grid$p;
    }
    _grid = grid$p;
    continue ;
  };
}

function step(grid) {
  return flash(grid.map(function (__x) {
                  return __x.map(function (x) {
                              return x + 1 | 0;
                            });
                }));
}

AoC.getInput("2021", "11", (function (input_) {
        var grid = Tools.lines(input_).map(function (line) {
              return line.split("").map(function (prim) {
                          return parseInt(prim, 10);
                        });
            });
        var part1 = function (_grid, _stepCount, _flashCount) {
          while(true) {
            var flashCount = _flashCount;
            var stepCount = _stepCount;
            var grid = _grid;
            var grid$p = step(grid);
            var flashCount$p = flashCount + grid$p.flat().filter(function (x) {
                  return x === 0;
                }).length | 0;
            if (stepCount === 100) {
              return flashCount$p;
            }
            _flashCount = flashCount$p;
            _stepCount = stepCount + 1 | 0;
            _grid = grid$p;
            continue ;
          };
        };
        console.log(part1(grid, 1, 0));
        var part2 = function (_grid, _stepCount) {
          while(true) {
            var stepCount = _stepCount;
            var grid = _grid;
            var grid$p = step(grid);
            if (grid$p.flat().every(function (x) {
                    return x === 0;
                  })) {
              return stepCount;
            }
            _stepCount = stepCount + 1 | 0;
            _grid = grid$p;
            continue ;
          };
        };
        console.log(part2(grid, 1));
        
      }));

exports.slice3 = slice3;
exports.charged = charged;
exports.flash = flash;
exports.step = step;
/*  Not a pure module */
