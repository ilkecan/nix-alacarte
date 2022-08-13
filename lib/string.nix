{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    concatStringsSep
    replaceStrings
  ;

  inherit (lib)
    concatStrings
    lowerChars
    splitString
    upperChars
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
