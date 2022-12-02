// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Tools = require("../Tools.bs.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");

function rotate(arr2d) {
  return Tools.exn(Tools.$$Array.get(arr2d, 0)).map(function (param, i, param$1) {
              return arr2d.map(function (x) {
                          return Tools.$$Array.get(x, i);
                        });
            });
}

function isWinner(board, seq) {
  return board.concat(rotate(board)).some(function (__x) {
              return __x.every(function (param) {
                          return seq.includes(param);
                        });
            });
}

function getScore(board, seq) {
  var unmarked = board.flat().filter(function (x) {
        return !seq.includes(x);
      });
  return Math.imul(Tools.reduce(unmarked, 0, (function (prim0, prim1) {
                    return prim0 + prim1 | 0;
                  })), Tools.last(seq));
}

AoC.getInput("2021", "4", (function (input_) {
        var input = input_.split("\n\n").map(function (prim) {
              return prim.trim();
            });
        var seq = Tools.exn(Tools.$$Array.get(input, 0)).split(",").map(function (prim) {
              return parseInt(prim, 10);
            });
        var boards = input.slice(1).map(function (str) {
              return Tools.lines(str).map(function (s) {
                          return s.trim().split(/\s+/).map(function (prim) {
                                      return parseInt(prim, 10);
                                    });
                        });
            });
        var getFirstWinnerScore = function (_pos) {
          while(true) {
            var pos = _pos;
            var seq$1 = Belt_Array.slice(seq, 0, pos);
            var board = boards.find((function(seq$1){
                return function (__x) {
                  return isWinner(__x, seq$1);
                }
                }(seq$1)));
            if (board !== undefined) {
              return getScore(board, seq$1);
            }
            _pos = pos + 1 | 0;
            continue ;
          };
        };
        console.log("First winner score: " + getFirstWinnerScore(1).toString());
        var getLastWinnerScore = function (_pos) {
          while(true) {
            var pos = _pos;
            var seq$1 = Belt_Array.slice(seq, 0, pos);
            var board = boards.find((function(seq$1){
                return function (board) {
                  return !isWinner(board, seq$1);
                }
                }(seq$1)));
            if (board !== undefined) {
              return getScore(board, Belt_Array.slice(seq, 0, pos + 1 | 0));
            }
            _pos = pos - 1 | 0;
            continue ;
          };
        };
        console.log("Last winner score: " + getLastWinnerScore(seq.length).toString());
        
      }));

exports.rotate = rotate;
exports.isWinner = isWinner;
exports.getScore = getScore;
/*  Not a pure module */