{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    concatStringsSep
    replaceStrings
    stringLength
    substring
    typeOf
  ;

  inherit (lib)
    concatStrings
    const
    findFirst
    flip
    id
    lowerChars
    optionalString
    pipe
    reverseList
    splitString
    toUpper
    upperChars
  ;

  inherit (lib.strings)
    floatToString
  ;

  inherit (nix-alacarte)
    addPrefix
    compose
    concatString
    concatStringWith
    indentByWith
    lines
    negative
    pair
    pipe'
    range'
    repeat
    replicate
    unlines
  ;

  inherit (nix-alacarte.nix)
    int
  ;

  inherit (nix-alacarte.internal)
    throw'
  ;

  snakeSep = "_";
  kebabSep = "-";
  snakeChars = map (c: "${snakeSep}${c}") lowerChars;
  kebabChars = map (c: "${kebabSep}${c}") lowerChars;

  findString' = reverse:
    let
      throw'' = throw'.appendScope "${optionalString reverse "r"}findString";
    in
    pattern:
      let
        patternType = typeOf pattern;
        patternLength = stringLength pattern;
        searcher =
          {
            string = str: i:
              substring i patternLength str == pattern;
            lambda = pattern;
          }.${patternType} or (throw'' [ "string" "lambda" ] "`typeOf pattern`" patternType);
      in
      str:
        pipe str [
          stringLength
          range'
          (if reverse then reverseList else id)
          (findFirst (searcher str) null)
        ];
in

{
  addPrefix = concatString;
  addSuffix = flip concatString;

  capitalize = string:
    let
      first = substring 0 1 string;
      rest = substring 1 (stringLength string) string;
    in
    (toUpper first) + rest;

  commands = splitString ";";
  uncommands = concatStringsSep ";";

  concatString = concatStringWith "";
  concatStringWith = separator: left: right:
    "${left}${separator}${right}";

  elements = splitString ",";
  unelements = concatStringsSep ",";

  findString = findString' false;
  rfindString = findString' true;

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
        float = floatToString;
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
    camelToKebab = replaceStrings upperChars kebabChars;
    camelToSnake = replaceStrings upperChars snakeChars;

    kebabToCamel = replaceStrings kebabChars upperChars;
    kebabToSnake = replaceStrings [ kebabSep ] [ snakeSep ];

    snakeToCamel = replaceStrings snakeChars upperChars;
    snakeToKebab = replaceStrings [ snakeSep ] [ kebabSep ];
  };

  lines = splitString "\n";
  unlines = concatStringsSep "\n";

  repeat = n: str:
    concatStrings (replicate n str);

  splitStringAt = index:
    let
      index' = if negative index then 0 else index;
    in
    str:
      pair
        (substring 0 index' str)
        (substring index' int.max str);

  words = splitString " ";
  unwords = concatStringsSep " ";
}
