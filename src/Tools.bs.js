// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Float = require("rescript/lib/js/belt_Float.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Belt_SortArray = require("rescript/lib/js/belt_SortArray.js");

function get(arr, i) {
  if (i >= 0 && i < arr.length) {
    return Caml_option.some(arr[i]);
  }
  
}

var $$Array = {
  get: get
};

function last(arr) {
  var l = arr.length;
  if (l !== 0) {
    return Caml_option.some(arr[l - 1 | 0]);
  }
  
}

function rest(arr) {
  return arr.slice(1);
}

function array_to_pair(arr) {
  var match = arr.length;
  if (match >= 2) {
    if (match < 3) {
      return arr;
    }
    
  } else if (match >= 0) {
    return ;
  }
  return [
          arr[0],
          arr[1]
        ];
}

function findMap(arr, f) {
  var _startAt = 0;
  var length = arr.length;
  while(true) {
    var startAt = _startAt;
    if (startAt === length) {
      return ;
    }
    var some = Curry._1(f, arr[startAt]);
    if (some !== undefined) {
      return some;
    }
    _startAt = startAt + 1 | 0;
    continue ;
  };
}

function count(arr, f) {
  return arr.filter(Curry.__1(f)).length;
}

function mapSum(arr, f) {
  return Belt_Array.reduce(arr, 0, (function (acc, x) {
                return acc + Curry._1(f, x) | 0;
              }));
}

function mapiPreserveRef(arr, f) {
  var changed = {
    contents: false
  };
  var result = arr.map(function (x, i, param) {
        var x$p = Curry._2(f, x, i);
        if (x !== x$p) {
          changed.contents = true;
        }
        return x$p;
      });
  if (changed.contents) {
    return result;
  } else {
    return arr;
  }
}

function lines(input) {
  return input.split("\n").filter(function (x) {
              return x !== "";
            });
}

function string_to_int_radix(str, radix) {
  var x = parseInt(str, radix);
  if (isNaN(x)) {
    return ;
  } else {
    return x | 0;
  }
}

function string_to_int(__x) {
  return string_to_int_radix(__x, 10);
}

function rangeSum(param, param$1, param$2) {
  var _acc = 0;
  var _min = param;
  while(true) {
    var min = _min;
    var acc = _acc;
    var acc$p = acc + Curry._1(param$2, min) | 0;
    if (min === param$1) {
      return acc$p;
    }
    _min = min + 1 | 0;
    _acc = acc$p;
    continue ;
  };
}

var filterMap = Belt_Array.keepMap;

var sort = Belt_SortArray.stableSortBy;

var range = Belt_Array.range;

var reduce = Belt_Array.reduce;

var reducei = Belt_Array.reduceWithIndex;

var string_to_float = Belt_Float.fromString;

var exn = Belt_Option.getExn;

var map_option = Belt_Option.map;

var flatMap_option = Belt_Option.flatMap;

exports.$$Array = $$Array;
exports.filterMap = filterMap;
exports.last = last;
exports.rest = rest;
exports.sort = sort;
exports.range = range;
exports.reduce = reduce;
exports.reducei = reducei;
exports.array_to_pair = array_to_pair;
exports.findMap = findMap;
exports.count = count;
exports.mapSum = mapSum;
exports.mapiPreserveRef = mapiPreserveRef;
exports.lines = lines;
exports.string_to_float = string_to_float;
exports.string_to_int_radix = string_to_int_radix;
exports.string_to_int = string_to_int;
exports.exn = exn;
exports.map_option = map_option;
exports.flatMap_option = flatMap_option;
exports.rangeSum = rangeSum;
/* No side effect */
