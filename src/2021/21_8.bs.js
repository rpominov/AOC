// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Tools = require("../Tools.bs.js");
var Caml_option = require("rescript/lib/js/caml_option.js");

function inside(inner, outer) {
  return inner.split("").every(function (param) {
              return outer.includes(param);
            });
}

function sameComb(a, b) {
  if (a.length === b.length) {
    return inside(a, b);
  } else {
    return false;
  }
}

AoC.getInput("2021", "8", (function (input_) {
        var input = Tools.lines(input_).map(function (line) {
              return Tools.array_to_pair(line.split(" | ").map(function (__x) {
                              return __x.split(" ");
                            }));
            });
        var partial_arg = [
          2,
          3,
          4,
          7
        ];
        var __x = Tools.count(input.flatMap(function (prim) {
                    return prim[1];
                  }).map(function (prim) {
                  return prim.length;
                }), (function (param) {
                return partial_arg.includes(param);
              }));
        console.log("part 1:", __x);
        var __x$1 = Tools.mapSum(input, (function (param) {
                var sample = param[0];
                var one = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              return x.length === 2;
                            })));
                var four = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              return x.length === 4;
                            })));
                var seven = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              return x.length === 3;
                            })));
                var eight = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              return x.length === 7;
                            })));
                var six = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              if (x.length === 6) {
                                return !inside(one, x);
                              } else {
                                return false;
                              }
                            })));
                var nine = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              if (x.length === 6) {
                                return inside(four, x);
                              } else {
                                return false;
                              }
                            })));
                var zero = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              if (x.length === 6 && x !== nine) {
                                return x !== six;
                              } else {
                                return false;
                              }
                            })));
                var five = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              if (x.length === 5) {
                                return inside(x, six);
                              } else {
                                return false;
                              }
                            })));
                var three = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              if (x.length === 5) {
                                return inside(one, x);
                              } else {
                                return false;
                              }
                            })));
                var two = Tools.exn(Caml_option.undefined_to_opt(sample.find(function (x) {
                              if (x.length === 5 && x !== three) {
                                return x !== five;
                              } else {
                                return false;
                              }
                            })));
                var mapping = [
                  zero,
                  one,
                  two,
                  three,
                  four,
                  five,
                  six,
                  seven,
                  eight,
                  nine
                ];
                return parseInt(param[1].map(function (x) {
                                    return mapping.findIndex(function (param) {
                                                return sameComb(x, param);
                                              });
                                  }).map(function (prim) {
                                  return prim.toString();
                                }).join(""), 10);
              }));
        console.log("part 2:", __x$1);
        
      }));

exports.inside = inside;
exports.sameComb = sameComb;
/*  Not a pure module */
