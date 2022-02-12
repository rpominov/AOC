// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Point = require("./Point.bs.js");

var directions = [
  /* N */0,
  /* S */1,
  /* E */2,
  /* W */3
];

var directions8 = [
  [
    /* N */0,
    undefined
  ],
  [
    /* N */0,
    /* E */2
  ],
  [
    /* E */2,
    undefined
  ],
  [
    /* E */2,
    /* S */1
  ],
  [
    /* S */1,
    undefined
  ],
  [
    /* S */1,
    /* W */3
  ],
  [
    /* W */3,
    undefined
  ],
  [
    /* W */3,
    /* N */0
  ]
];

function move(distanceOpt, x, y, direction) {
  var distance = distanceOpt !== undefined ? distanceOpt : 1;
  switch (direction) {
    case /* N */0 :
        return Point.make(x, y + distance | 0);
    case /* S */1 :
        return Point.make(x, y - distance | 0);
    case /* E */2 :
        return Point.make(x + distance | 0, y);
    case /* W */3 :
        return Point.make(x - distance | 0, y);
    
  }
}

function move8(distanceOpt, x, y, direction) {
  var distance = distanceOpt !== undefined ? distanceOpt : 1;
  var p = move(distance, x, y, direction[0]);
  var d = direction[1];
  if (d !== undefined) {
    return move(distance, p.x, p.y, d);
  } else {
    return p;
  }
}

function sumByDirection(f) {
  return ((Curry._1(f, /* N */0) + Curry._1(f, /* S */1) | 0) + Curry._1(f, /* E */2) | 0) + Curry._1(f, /* W */3) | 0;
}

exports.directions = directions;
exports.directions8 = directions8;
exports.move = move;
exports.move8 = move8;
exports.sumByDirection = sumByDirection;
/* Point Not a pure module */