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
    mkToString
  ;

  snakeSep = "_";
  kebabSep = "-";
  snakeChars = map (c: "${snakeSep}${c}") lowerChars;
  kebabChars = map (c: "${kebabSep}${c}") lowerChars;
in

{
  fmtValue = args:
    mkToString ({ bool = boolToString; } // args);

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

  mkToString = {
    bool ? null,
    float ? null,
    int ? null,
    lambda ? null,
    list ? null,
    null ? null,
    path ? null,
    set ? null,
    string ? null,
  }@fs: value:
    let
      fs' = {
        bool = v: if v then "1" else "";
        float = floatToString;
        null = const "";
        string = id;
      } // fs;
      f = fs'.${typeOf value} or toString;
    in
    f value;

  repeat = n: str:
    concatStrings (replicate n str);

  words = splitString " ";
  unwords = concatStringsSep " ";
}
