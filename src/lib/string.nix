{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    typeOf
  ;

  inherit (lib)
    const
    id
    lowerChars
    max
    min
    pipe
    toUpper
    upperChars
  ;

  inherit (nix-alacarte)
    addPrefix
    clamp
    indentByWith
    int
    lines
    list
    negative
    options
    pair
    pipe'
    range1
    repeat
    replicate
    str
    unlines
  ;

  inherit (str)
    concat
    drop
    intersperse
    length
    optional
    replace
    slice
    split
    take
  ;

  inherit (nix-alacarte.internal)
    normalizeNegativeIndex
    throw
  ;

  snakeSep = "_";
  kebabSep = "-";
  snakeChars = map (c: "${snakeSep}${c}") lowerChars;
  kebabChars = map (c: "${kebabSep}${c}") lowerChars;

  find' = reverse:
    let
      throw' = throw.appendScope "${optional reverse "r"}findString";
    in
    pattern:
      let
        patternType = typeOf pattern;
        patternLength = length pattern;
        searcher =
          {
            string = str: i:
              slice i (i + patternLength) str == pattern;
            lambda = pattern;
          }.${patternType} or (throw' [ "string" "lambda" ] "`typeOf pattern`" patternType);
      in
      str:
        pipe str [
          length
          range1
          (if reverse then list.reverse else id)
          (list.find (searcher str))
        ];

  sliceUnsafe = start: end:
    builtins.substring start (end - start);

  slice' =
    {
      normalizeNegativeIndex ? const id,
    }:
    start: end: string:
      let
        length' = length string;
        normalizeNegativeIndex' = normalizeNegativeIndex length';
        start' = pipe start [
          normalizeNegativeIndex'
          (max 0)
        ];
        end' = pipe end [
          normalizeNegativeIndex'
          (max start')
        ];
      in
      sliceUnsafe start' end' string;
in

{
  addPrefix = prefix: string:
    prefix + string;

  addSuffix = suffix: string:
    string + suffix;

  capitalize = string:
    let
      first = slice 0 1 string;
      rest = slice 1 int.MAX string;
    in
    (toUpper first) + rest;

  commands = split ";";

  elements = split ",";

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
      indentation = repeat count char;
    in
    pipe' [
      lines
      (map (addPrefix indentation))
      unlines
    ];

  letterCase = {
    camelToKebab = replace upperChars kebabChars;
    camelToSnake = replace upperChars snakeChars;

    kebabToCamel = replace kebabChars upperChars;
    kebabToSnake = replace [ kebabSep ] [ snakeSep ];

    snakeToCamel = replace snakeChars upperChars;
    snakeToKebab = replace [ snakeSep ] [ kebabSep ];
  };

  lines = split "\n";

  repeat = n: str:
    concat (replicate n str);

  str = {
    __functor = _:
      options.str;

    concat = lib.concatStrings;

    concatMap = lib.concatMapStrings;

    drop = count:
      slice' { } count int.MAX;

    find = find' false;

    intersperse = builtins.concatStringsSep;

    length = builtins.stringLength;

    optional = lib.optionalString;

    rfind = find' true;

    replace = builtins.replaceStrings;

    slice = slice' { inherit normalizeNegativeIndex; };

    split = lib.splitString;

    splitAt = index: string:
      let
        length' = length string;
        index' = pipe index [
          (normalizeNegativeIndex length')
          (clamp 0 length')
        ];
      in
      pair (take index' string) (drop index' string);


    take = slice' { } 0;

    unsafeDiscardContext = builtins.unsafeDiscardStringContext;
  };

  uncommands = intersperse ";";

  unelements = intersperse ",";

  unlines = intersperse "\n";

  unwords = intersperse " ";

  words = split " ";
}
