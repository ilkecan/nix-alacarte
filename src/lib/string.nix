{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    concatStringsSep
    stringLength
    replaceStrings
    substring
    typeOf
  ;

  inherit (lib)
    concatStrings
    const
    flip
    id
    lowerChars
    splitString
    toUpper
    upperChars
  ;

  inherit (lib.strings)
    floatToString
  ;

  inherit (nix-alacarte)
    addPrefix
    concatString
    concatStringWith
    indentByWith
    lines
    nix
    pipe'
    repeat
    replicate
    unlines
  ;

  snakeSep = "_";
  kebabSep = "-";
  snakeChars = map (c: "${snakeSep}${c}") lowerChars;
  kebabChars = map (c: "${kebabSep}${c}") lowerChars;
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

  splitStringAt = index: str: {
    left = substring 0 index str;
    right = substring index nix.int.max str;
  };

  words = splitString " ";
  unwords = concatStringsSep " ";
}
