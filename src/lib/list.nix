{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    ceil
    elemAt
    seq
  ;

  inherit (lib)
    const
    flip
    max
    pipe
  ;

  inherit (nix-alacarte)
    add
    clamp
    div'
    equalTo
    fn
    fst
    indexed
    int
    interval
    list
    mul
    not
    notEqualTo
    options
    pair
    range
    range1
    range2
    range3
    snd
    sub'
  ;

  inherit (nix-alacarte.internal)
    assertion
    normalizeNegativeIndex
  ;

  inherit (nix-alacarte.internal.list)
    foldStartingWithHead
    slice'
    sliceUnsafe
  ;

  self = list;
in

{
  indexed = list:
    let
      elemAt' = elemAt list;
    in
    pipe list [
      self.length
      range1
      (self.map (index: pair index (elemAt' index)))
    ];

  list =
    let
      assertion' = assertion.appendScope "list";
    in
    {
      # NOTE: i don't like this
      __functor = _:
        options.list;

      all = builtins.all;

      allEqual = list:
        self.all (equalTo (self.head list)) list;

      any = builtins.any;

      append = right: left:
        left ++ right;

      at =
        let
          assertion'' = assertion'.appendScope "at";
        in
        index: list:
          let
            length = self.length list;
            interval' = interval (-length) length;
          in
          assert assertion''.indexBounds interval' index list;
          let
            index' = normalizeNegativeIndex length index;
          in
          elemAt list index';

      concat = builtins.concatLists;

      concat2 = self.intercalate2 [ ];

      concatMap = builtins.concatMap;

      cons = fn.compose [ self.prepend self.singleton ];

      count = lib.count;

      difference = flip self.difference';

      difference' = lib.subtractLists;

      drop = count:
        slice' { } count int.MAX;

      elem = builtins.elem;

      elemIndex = fn.compose [ self.findIndex equalTo ];

      elemIndices = fn.compose [ self.findIndices equalTo ];

      empty = equalTo [ ];

      filter = builtins.filter;

      filterMap = f:
        fn.pipe' [
          (self.map f)
          (self.remove null)
        ];

      find = pred:
        lib.findFirst pred null;

      findIndex = predicate: list:
        let
          indices = self.findIndices predicate list;
        in
        if self.empty indices then null else self.head indices;

      findIndices = predicate: list:
        let
          elemAt' = elemAt list;
        in
        pipe list [
          self.length
          range1
          (self.filter (fn.compose [ predicate elemAt' ]))
        ];

      flatten = list:
        let
          assertion'' = assertion'.appendScope "flatten";
        in
        assert assertion'' (self.is list) "not a list";
        self.concatMap lib.flatten list;

      foldl = lib.foldl;

      foldl' = builtins.foldl';

      foldr = lib.foldr;

      foldr' = operator: initial: list:
        let
          length' = self.length list;
          fold = n: value:
            let
              result = operator (self.at n list) value;
            in
            if n == 0
              then result
              else seq result (fold (n - 1) result);
        in
        fold (length' - 1) initial;

      forEach = flip self.map;

      gen = builtins.genList;

      groupBy = builtins.groupBy;

      head = list:
        let
          assertion'' = assertion'.appendScope "head";
        in
        assert assertion'' (self.notEmpty list) "empty list";
        builtins.head list;

      ifilter = predicate:
        let
          predicate' = pair.uncurry predicate;
        in
        fn.pipe' [
          indexed
          (self.filter predicate')
          (self.map snd)
        ];

      imap = lib.imap0;

      init = list:
        let
          assertion'' = assertion'.appendScope "init";
        in
        assert assertion'' (self.notEmpty list) "empty list";
        lib.init list;

      intercalate = seperator:
        fn.compose [ self.concat (self.intersperse seperator) ];

      intercalate2 = seperator: left: right:
        left ++ seperator ++ right;

      intersect = lib.intersectLists;

      intersperse = seperator:
        let
          operator = accumulator: element:
            accumulator ++ [ seperator element ];
        in
        list:
          let
            result = self.uncons list;
          in
          if result == null
            then [ ]
            else
              let
                head = fst result;
                tail = snd result;
              in
              self.foldl' operator [ head ] tail;

      is = builtins.isList;

      last = list:
        let
          assertion'' = assertion'.appendScope "last";
        in
        assert assertion'' (self.notEmpty list) "empty list";
        lib.last list;

      length = builtins.length;

      map = builtins.map;

      maximum = foldStartingWithHead "maximum" lib.max;

      mapToAttrs = f:
        fn.compose [ self.toAttrs (self.map f) ];

      minimum = foldStartingWithHead "minimum" lib.min;

      notElem = x:
        fn.compose [ not (self.elem x) ];

      notEmpty = notEqualTo [ ];

      optional = lib.optionals;

      partition = predicate: list:
        let
          partitioned = builtins.partition predicate list;
        in
        pair partitioned.right partitioned.wrong;

      prepend = left: right:
        left ++ right;

      product = self.foldl' builtins.mul 1;

      remove = lib.remove;

      replicate = n: val:
        self.gen (const val) n;

      reverse = list:
        let
          start = self.length list - 1;
          end = -1;
        in
        sliceUnsafe { stride = -1; } start end list;

      singleton = lib.singleton;

      slice = slice' { inherit normalizeNegativeIndex; };

      snoc = fn.compose [ self.append self.singleton ];

      sort = builtins.sort;

      splitAt = index: list:
        let
          length = self.length list;
          index' = pipe index [
            (normalizeNegativeIndex length)
            (clamp 0 length)
          ];
        in
        pair (self.take index' list) (self.drop index' list);

      sum = self.foldl' builtins.add 0;

      tail = list:
        let
          assertion'' = assertion'.appendScope "tail";
        in
        assert assertion'' (self.notEmpty list) "empty list";
        builtins.tail list;

      take = slice' { } 0;

      to = lib.toList;

      toAttrs =
        fn.pipe' [
          (self.map (pair.uncurry lib.nameValuePair))
          builtins.listToAttrs
        ];

      uncons = list:
        if self.empty list
          then null
          else pair (self.head list) (self.tail list);

      union = left:
        fn.pipe' [
          (self.difference' left)
          (self.prepend left)
          self.unique
        ];

      unique = lib.unique;

      unzip = list:
        pair (self.map fst list) (self.map snd list);

      zip = self.zipWith pair;

      zipWith = lib.zipListsWith;
    };

  range = range2;

  range1 = range 0;

  range2 = range3 1;

  range3 = stride:
    let
      stride' = int.toFloat stride;
    in
    start:
      fn.pipe' [
        (sub' start)
        (div' stride')
        ceil
        (max 0)
        (self.gen (fn.compose [ (add start) (mul stride) ]))
      ];
}
