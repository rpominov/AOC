open Tools
module Map = Belt.Map

let hexToB =
  [
    ("0", "0000"),
    ("1", "0001"),
    ("2", "0010"),
    ("3", "0011"),
    ("4", "0100"),
    ("5", "0101"),
    ("6", "0110"),
    ("7", "0111"),
    ("8", "1000"),
    ("9", "1001"),
    ("A", "1010"),
    ("B", "1011"),
    ("C", "1100"),
    ("D", "1101"),
    ("E", "1110"),
    ("F", "1111"),
  ]->Map.String.fromArray

let take = (seq, n) => {
  if seq->Js.String2.length < n {
    failwith(j`$__LINE__: take($seq, $n)`)
  }
  (seq->Js.String2.slice(~from=0, ~to_=n), seq->Js.String2.sliceToEnd(~from=n))
}

type header = {ver: int, id: int}

let getHeader = seq => {
  let (ver, seq1) = seq->take(3)
  let (id, seq2) = seq1->take(3)
  ({ver: ver->string_to_int_radix(2)->unsafe, id: id->string_to_int_radix(2)->unsafe}, seq2)
}

type packetLength = Bytes(int) | Packets(int)

let getLength = seq => {
  let (ver, seq1) = seq->take(1)
  switch ver {
  | "1" => {
      let (data, seq2) = seq1->take(11)
      (Packets(data->string_to_int_radix(2)->unsafe), seq2)
    }
  | "0" => {
      let (data, seq2) = seq1->take(15)
      (Bytes(data->string_to_int_radix(2)->unsafe), seq2)
    }
  | _ => failwith(seq)
  }
}

let rec getLiteralBlocks = (acc, seq) => {
  let (isLast, seq) = seq->take(1)
  let (block, seq) = seq->take(4)
  let acc1 = acc->concat([block])
  switch isLast {
  | "0" => (acc1, seq)
  | "1" => getLiteralBlocks(acc1, seq)
  | _ => failwith(seq)
  }
}
let getLiteral = seq => {
  let (blocks, seq) = getLiteralBlocks([], seq)
  (blocks->join("")->string_to_int_radix(2)->unsafe->int_to_float, seq)
}

type rec packet =
  | Literal({header: header, value: float})
  | Operator({header: header, length: packetLength, subPackets: Js.Array.t<packet>})

let rec parsePacket = seq => {
  let (header, seq) = seq->getHeader

  if header.id == 4 {
    let (val, seq) = seq->getLiteral
    (Literal({header: header, value: val}), seq)
  } else {
    let (l, seq) = seq->getLength

    let isExhausted = switch l {
    | Bytes(x) => (curSeq, _) => seq->Js.String2.length - curSeq->Js.String2.length == x
    | Packets(x) => (_, curSubPackets) => curSubPackets->length == x
    }

    let lastSeq = ref(seq)
    let subPackets = []

    while !isExhausted(lastSeq.contents, subPackets) {
      let (packet, seq) = parsePacket(lastSeq.contents)
      subPackets->Js.Array2.push(packet)->ignore
      lastSeq := seq
    }

    (Operator({header: header, length: l, subPackets: subPackets}), lastSeq.contents)
  }
}

let rec packetToString = packet => {
  switch packet {
  | Literal({header: _, value}) => value->float_to_string
  | Operator({header, length: _, subPackets}) => {
      let name = switch header.id {
      | 0 => "sum"
      | 1 => "mul"
      | 2 => "min"
      | 3 => "max"
      | 5 => "gt"
      | 6 => "lt"
      | 7 => "eq"
      | _ => raise(Not_found)
      }
      `${name}(${subPackets->map(packetToString)->join(", ")})`
    }
  }
}

let rec sumVersions = packet => {
  switch packet {
  | Literal({header, value: _}) => header.ver
  | Operator({header, length: _, subPackets}) =>
    header.ver + subPackets->map(sumVersions)->reduce(0, \"+")
  }
}

let rec execute = packet => {
  switch packet {
  | Literal({header: _, value}) => value
  | Operator({header, length: _, subPackets: sub}) =>
    switch (header.id, sub->map(execute)) {
    | (0, arr) => arr->reduce(0., \"+.")
    | (1, arr) => arr->reduce(1., \"*.")
    | (2, arr) => arr->Js.Math.minMany_float
    | (3, arr) => arr->Js.Math.maxMany_float
    | (5, [f, s]) => f > s ? 1. : 0.
    | (6, [f, s]) => f < s ? 1. : 0.
    | (7, [f, s]) => f == s ? 1. : 0.
    | _ => raise(Not_found)
    }
  }
}

AoC.getInput("2021", "16", input_ => {
  let input = input_->split("")->filterMap(Map.String.get(hexToB))->Js.String.concatMany("")

  let (pack, _) = input->parsePacket
  pack->packetToString->Js.log

  // part 1
  pack->sumVersions->Js.log

  // part 2
  pack->execute->Js.log
})
