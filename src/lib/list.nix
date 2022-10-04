{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elemAt
    ceil
  ;

  inherit (lib)
    const
    flip
    id
    max
    min
    pipe
  ;

  inherit (nix-alacarte)
    add
    clamp
    compose
    div'
    equalTo
    fst
    indexed
    int
    list
    mul
    negative
    not
    notEqualTo
    options
    pair
    pipe'
    range
    range'
    range3
    snd
    sub'
  ;

  inherit (list)
    all
    append
    concat
    difference'
    drop
    elem
    empty
    filter
    findIndex
    findIndices
    foldl'
    gen
    head
    intersperse
    length
    notEmpty
    prepend
    singleton
    slice
    tail
    take
    toAttrs
    uncons
    unique
    zipWith
  ;

  inherit (nix-alacarte.internal)
    assertion
    normalizeNegativeIndex
  ;

  sliceUnsafe =
    {
      step ? 1,
    }:
    start: end: list:
      map (elemAt list) (range3 step start end);

  slice' =
    {
      normalizeNegativeIndex ? const id,
      step ? 1,
    }:
    start: end: list:
      let
        length' = length list;
        normalizeNegativeIndex' = normalizeNegativeIndex length';
        start' = pipe start [
          normalizeNegativeIndex'
          (max 0)
        ];
        end' = pipe end [
          normalizeNegativeIndex'
          (min length')
        ];
      in
      sliceUnsafe { inherit step; } start' end' list;
in

{
  indexed = list:
    let
      elemAt' = elemAt list;
    in
    map (index: pair index (elemAt' index)) (range' (length list));

  list =
    let
      assertion' = assertion.appendScope "list";

      foldStartingWithHead = scope:
        let
          assertion'' = assertion'.appendScope scope;
        in
        f: list:
          assert assertion'' (notEmpty list) "empty list";
          let
            initial = head list;
          in
          foldl' f initial list;
    in
    {
      # NOTE: i don't like this
      __functor = _:
        options.list;

      all = builtins.all;

      allEqual = list:
        all (equalTo (head list)) list;

      any = builtins.any;

      append = right: left:
        left ++ right;

      at = index:
        let
          assertion'' = assertion'.appendScope "at";
        in
        assert assertion'' (!negative index) "negative index: `${toString index}`";
        list:
          let
            length' = length list;
          in
          assert assertion'' (index < length')
            "index out of bounds: the length is `${toString length'}` but the index is `${toString index}`";
          elemAt list index;

      concat = builtins.concatLists;

      concatMap = builtins.concatMap;

      cons = compose [ prepend singleton ];

      count = lib.count;

      difference = flip difference';

      difference' = lib.subtractLists;

      drop = count:
        slice' { } count int.MAX;

      elem = builtins.elem;

      elemIndex = compose [ findIndex equalTo ];

      elemIndices = compose [ findIndices equalTo ];

      empty = equalTo [ ];

      filter = builtins.filter;

      find = pred:
        lib.findFirst pred null;

      findIndex = predicate: list:
        let
          indices = findIndices predicate list;
        in
        if empty indices then null else head indices; 

      findIndices = predicate: list:
        let
          elemAt' = elemAt list;
        in
        pipe list [
          length
          range'
          (filter (compose [ predicate elemAt' ]))
        ];

      foldl = lib.foldl;

      foldl' = builtins.foldl';

      foldr = lib.foldr;

      forEach = flip map;

      gen = builtins.genList;

      groupBy = builtins.groupBy;

      head = list:
        let
          assertion'' = assertion'.appendScope "head";
        in
        assert assertion'' (notEmpty list) "empty list";
        builtins.head list;

      ifilter = predicate:
        let
          predicate' = pair.uncurry predicate;
        in
        pipe' [
          indexed
          (filter predicate')
          (map snd)
        ];

      imap = lib.imap0;

      init = list:
        let
          assertion'' = assertion'.appendScope "init";
        in
        assert assertion'' (notEmpty list) "empty list";
        lib.init list;

      intercalate = seperator:
        compose [ concat (intersperse seperator) ];

      intersect = lib.intersectLists;

      intersperse = seperator: list:
        let
          result = uncons list;
        in
        if result == null
          then [ ]
          else
            let
              head = fst result;
              tail = snd result;
            in
        foldl' (accumulator: element: accumulator ++ [ seperator element ] ) [ head ] tail;

      is = builtins.isList;

      last = list:
        let
          assertion'' = assertion'.appendScope "last";
        in
        assert assertion'' (notEmpty list) "empty list";
        lib.last list;

      length = builtins.length;

      map = builtins.map;

      maximum = foldStartingWithHead "maximum" lib.max;

      mapToAttrs = f:
        compose [ toAttrs (map f) ];

      minimum = foldStartingWithHead "minimum" lib.min;

      notElem = x:
        compose [ not (elem x) ];

      notEmpty = notEqualTo [ ];

      optional = lib.optionals;

      partition = predicate: list:
        let
          partitioned = builtins.partition predicate list;
        in
        pair partitioned.right partitioned.wrong;

      prepend = left: right:
        left ++ right;

      product = foldl' builtins.mul 1;

      remove = lib.remove;

      replicate = n: val:
        gen (const val) n;

      reverse = list:
        let
          start = length list - 1;
          end = -1;
        in
        sliceUnsafe { step = -1; } start end list;

      singleton = lib.singleton;

      slice = slice' { inherit normalizeNegativeIndex; };

      snoc = compose [ append singleton ];

      sort = builtins.sort;

      splitAt = index: list:
        let
          length' = length list;
          index' = pipe index [
            (normalizeNegativeIndex length')
            (clamp 0 length')
          ];
        in
        pair (take index' list) (drop index' list);

      sum = foldl' builtins.add 0;

      tail = list:
        let
          assertion'' = assertion'.appendScope "tail";
        in
        assert assertion'' (notEmpty list) "empty list";
        builtins.tail list;

      take = slice' { } 0;

      to = lib.toList;

      toAttrs =
        pipe' [
          (map (pair: lib.nameValuePair (fst pair) (snd pair)))
          builtins.listToAttrs
        ];

      uncons = list:
        if empty list
          then null
          else pair (head list) (tail list);

      union = left:
        compose [ unique (prepend left) (difference' left) ];

      unique = lib.unique;

      unzip = list:
        pair (map fst list) (map snd list);

      zip = zipWith pair;

      zipWith = lib.zipListsWith;
    };

  range = range3 1;

  range' = range 0;

  range3 = step:
    let
      step' = int.toFloat step;
    in
    start:
      pipe' [
        (sub' start)
        (div' step')
        ceil
        (max 0)
        (gen (compose [ (add start) (mul step) ]))
      ];

  # inherits
  inherit (list)
    replicate
  ;
}
