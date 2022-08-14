{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    concatStringsSep
    replaceStrings
    typeOf
  ;

  inherit (lib)
    boolToString
    concatStrings
    const
    id
    lowerChars
    splitString
    upperChars
  ;

  inherit (lib.strings)
    floatToString
  ;

  inherit (nix-utils)
    replicate
  ;

  snakeSep = "_";
  kebabSep = "-";
  snakeChars = map (c: "${snakeSep}${c}") lowerChars;
  kebabChars = map (c: "${kebabSep}${c}") lowerChars;
in

{
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
  }@args: value:
    let
      fmts = {
        bool = boolToString;
        float = floatToString;
        int = toString;
        lambda = toString;
        list = toString;
        null = const "";
        path = toString;
        set = toString;
        string = id;
      } // args;
      fmt = fmts.${typeOf value} or toString;
    in
    fmt value;

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

  words = splitString " ";
  unwords = concatStringsSep " ";
}
