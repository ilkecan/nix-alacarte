{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    seq
    typeOf
  ;

  inherit (lib)
    const
    id
    pipe
    upperChars
  ;

  inherit (nix-alacarte)
    clamp
    compose
    equalTo
    fst
    indentByWith
    int
    interval
    lines
    list
    notEqualTo
    options
    pair
    pipe'
    snd
    str
    unlines
  ;

  inherit (nix-alacarte.internal)
    assertion
    normalizeNegativeIndex
  ;

  inherit (nix-alacarte.internal.str)
    find'
    kebabChars
    kebabSep
    slice'
    snakeChars
    snakeSep
  ;

  self = str;
in

{
  commands = self.split ";";

  elements = self.split ",";

  fmtValue = {
    bool ? null,
    float ? null,
    int ? null,
    lambda ? null,
    list ? null,
    null ? null,
    path ? null,
    set ? null,
    string ? null,
  }@fmtFs: value:
    let
      fmtFs' = {
        bool = v: if v then "1" else "";
        float = nix-alacarte.float.toString;
        null = const "";
        string = id;
      } // fmtFs;
      fmt = fmtFs'.${typeOf value} or toString;
    in
    fmt value;

  indentBy = indentByWith " ";

  indentByWith = char: count:
    let
      indentation = self.replicate count char;
    in
    pipe' [
      lines
      (list.map (self.prepend indentation))
      unlines
    ];

  letterCase = {
    camelToKebab = self.replace upperChars kebabChars;
    camelToSnake = self.replace upperChars snakeChars;

    kebabToCamel = self.replace kebabChars upperChars;
    kebabToSnake = self.replace [ kebabSep ] [ snakeSep ];

    snakeToCamel = self.replace snakeChars upperChars;
    snakeToKebab = self.replace [ snakeSep ] [ kebabSep ];
  };

  lines = self.split "\n";

  str =
    let
      assertion' = assertion.appendScope "str";
    in
    {
      __functor = _:
        options.str;

      append = suffix: string:
        string + suffix;

      at =
        let
          assertion'' = assertion'.appendScope "at";
        in
        index: string:
          let
            length = self.length string;
            interval' = interval (-length) length;
          in
          assert assertion''.indexBounds interval' index string;
          let
            index' = normalizeNegativeIndex length index;
          in
          builtins.substring index' 1 string;

      capitalize = string:
        let
          result = self.splitAt 1 string;
        in
        (self.upper (fst result)) + (snd result);

      concat = lib.concatStrings;

      concat2 = left: right:
        left + right;

      concatMap = lib.concatMapStrings;

      cons = compose [ self.prepend self.singleton ];

      drop = count:
        slice' { } count int.MAX;

      empty = equalTo "";

      find = find' false;

      foldl = operator: initial: string:
        let
          length' = self.length string;
          fold = n:
            if n == -1
              then initial
              else operator (fold (n - 1)) (self.at n string);
        in
        fold (length' - 1);

      foldl' = operator: initial: string:
        let
          length' = self.length string;
          end = length' - 1;
          fold = n: value:
            let
              result = operator value (self.at n string);
            in
            if n == end
              then result
              else seq result (fold (n + 1) result);
        in
        fold 0 initial;

      foldr = operator: initial: string:
        let
          length' = self.length string;
          fold = n:
            if n == length'
              then initial
              else operator (self.at n string) (fold (n + 1));
        in
        fold 0;

      foldr' = operator: initial: string:
        let
          length' = self.length string;
          fold = n: value:
            let
              result = operator (self.at n string) value;
            in
            if n == 0
              then result
              else seq result (fold (n - 1) result);
        in
        fold (length' - 1) initial;

      head = string:
        let
          assertion'' = assertion'.appendScope "head";
        in
        assert assertion'' (self.notEmpty string) "empty string";
        self.at 0 string;

      init = string:
        let
          assertion'' = assertion'.appendScope "init";
        in
        assert assertion'' (self.notEmpty string) "empty string";
        self.take (self.length string - 1) string;

      intercalate = builtins.concatStringsSep;

      last = string:
        let
          assertion'' = assertion'.appendScope "last";
        in
        assert assertion'' (self.notEmpty string) "empty string";
        self.at (self.length string - 1) string;

      length = builtins.stringLength;

      lower = lib.toLower;

      notEmpty = notEqualTo "";

      optional = lib.optionalString;

      prepend = prefix: string:
        prefix + string;

      rfind = find' true;

      replace = builtins.replaceStrings;

      replicate = n:
        pipe' [
          (list.replicate n)
          self.concat
        ];

      singleton = character:
        let
          assertion' = assertion.appendScope "singleton";
        in
        assert assertion' (self.length character == 1) "not a character: `${character}`";
        character;

      slice = slice' { inherit normalizeNegativeIndex; };

      split = lib.splitString;

      splitAt = index: string:
        let
          length = self.length string;
          index' = pipe index [
            (normalizeNegativeIndex length)
            (clamp 0 length)
          ];
        in
        pair (self.take index' string) (self.drop index' string);

      tail = string:
        let
          assertion'' = assertion'.appendScope "tail";
        in
        assert assertion'' (self.notEmpty string) "empty string";
        self.drop 1 string;

      take = slice' { } 0;

      unsafeDiscardContext = builtins.unsafeDiscardStringContext;

      upper = lib.toUpper;
    };

  uncommands = self.intercalate ";";

  unelements = self.intercalate ",";

  unlines = self.intercalate "\n";

  unwords = self.intercalate " ";

  words = self.split " ";
}
