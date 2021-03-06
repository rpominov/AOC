// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AoC = require("../AoC.bs.js");
var Curry = require("rescript/lib/js/curry.js");
var Tools = require("../Tools.bs.js");
var Pervasives = require("rescript/lib/js/pervasives.js");

AoC.getInput("2020", "4", (function (input_) {
        var passports = input_.split("\n\n").map(function (str) {
              return str.split(/\s/).filter(function (x) {
                            return x !== "";
                          }).map(function (pair) {
                          var match = pair.split(":");
                          if (match.length !== 2) {
                            return Pervasives.failwith("Bad pair: " + pair);
                          }
                          var key = match[0];
                          var val = match[1];
                          return [
                                  key,
                                  val
                                ];
                        });
            });
        var required = [
          [
            "byr",
            (function (s) {
                var v = Tools.string_to_int(s);
                if (v !== undefined && v >= 1920) {
                  return v <= 2002;
                } else {
                  return false;
                }
              })
          ],
          [
            "iyr",
            (function (s) {
                var v = Tools.string_to_int(s);
                if (v !== undefined && v >= 2010) {
                  return v <= 2020;
                } else {
                  return false;
                }
              })
          ],
          [
            "eyr",
            (function (s) {
                var v = Tools.string_to_int(s);
                if (v !== undefined && v >= 2020) {
                  return v <= 2030;
                } else {
                  return false;
                }
              })
          ],
          [
            "hgt",
            (function (s) {
                var match = s.match(/^([0-9]+)(cm|in)$/);
                if (match === null) {
                  return false;
                }
                if (match.length !== 3) {
                  return false;
                }
                var n = match[1];
                var match$1 = match[2];
                switch (match$1) {
                  case "cm" :
                      if (Tools.string_to_int(n) >= 150) {
                        return Tools.string_to_int(n) <= 193;
                      } else {
                        return false;
                      }
                  case "in" :
                      if (Tools.string_to_int(n) >= 59) {
                        return Tools.string_to_int(n) <= 76;
                      } else {
                        return false;
                      }
                  default:
                    return false;
                }
              })
          ],
          [
            "hcl",
            (function (s) {
                return /^#[0-9a-f]{6}$/.test(s);
              })
          ],
          [
            "ecl",
            (function (s) {
                return [
                          "amb",
                          "blu",
                          "brn",
                          "gry",
                          "grn",
                          "hzl",
                          "oth"
                        ].includes(s);
              })
          ],
          [
            "pid",
            (function (s) {
                return /^[0-9]{9}$/.test(s);
              })
          ]
        ];
        console.log(Tools.count(passports, (function (data) {
                    var fields = data.map(function (param) {
                          return param[0];
                        });
                    return required.every(function (param) {
                                return fields.includes(param[0]);
                              });
                  })));
        console.log(Tools.count(passports, (function (data) {
                    return required.every(function (param) {
                                var f = param[1];
                                var k = param[0];
                                return data.some(function (param) {
                                            if (param[0] === k) {
                                              return Curry._1(f, param[1]);
                                            } else {
                                              return false;
                                            }
                                          });
                              });
                  })));
        
      }));

/*  Not a pure module */
