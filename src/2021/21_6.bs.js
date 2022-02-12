// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Curry = require("rescript/lib/js/curry.js");
var Int64 = require("rescript/lib/js/int64.js");
var Tools = require("../Tools.bs.js");
var Caml_int64 = require("rescript/lib/js/caml_int64.js");

function modAt(arr, i, f) {
  return arr.map(function (y, _i, param) {
              if (i === _i) {
                return Curry._1(f, y);
              } else {
                return y;
              }
            });
}

function prog(groups) {
  var zeros = Tools.exn(Tools.$$Array.get(groups, 0));
  return modAt(groups.slice(1).concat([zeros]), 6, (function (param) {
                return Caml_int64.add(zeros, param);
              }));
}

AoC.getInput("2021", "6", (function (input_) {
        var groups = Tools.reduce(input_.split(",").map(function (prim) {
                  return parseInt(prim, 10);
                }), [
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0
              ].map(Caml_int64.of_int32), (function (acc, x) {
                return modAt(acc, x, (function (param) {
                              return Caml_int64.add(Int64.one, param);
                            }));
              }));
        console.log(Int64.to_string(Tools.reduce(Tools.reduce(Tools.range(1, 256), groups, (function (acc, param) {
                            return prog(acc);
                          })), Int64.zero, Caml_int64.add)));
        
      }));

exports.modAt = modAt;
exports.prog = prog;
/*  Not a pure module */