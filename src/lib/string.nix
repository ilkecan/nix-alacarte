{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    replaceStrings
    substring
    typeOf
  ;

  inherit (lib)
    const
    id
    lowerChars
    pipe
    reverseList
    toUpper
    upperChars
  ;

  inherit (nix-alacarte)
    addPrefix
    float
    indentByWith
    int
    lines
    list
    negative
    pair
    pipe'
    range'
    repeat
    replicate
    unlines
  ;

  inherit (nix-alacarte.string)
    concat
    intersperse
    length
    optional
    split
  ;

  inherit (nix-alacarte.internal)
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
              substring i patternLength str == pattern;
            lambda = pattern;
          }.${patternType} or (throw' [ "string" "lambda" ] "`typeOf pattern`" patternType);
      in
      str:
        pipe str [
          length
          range'
          (if reverse then reverseList else id)
          (list.find (searcher str))
        ];
in

{
  addPrefix = prefix: string:
    prefix + string;

  addSuffix = suffix: string:
    string + suffix;

  capitalize = string:
    let
      first = substring 0 1 string;
      rest = substring 1 (length string) string;
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
    camelToKebab = replaceStrings upperChars kebabChars;
    camelToSnake = replaceStrings upperChars snakeChars;

    kebabToCamel = replaceStrings kebabChars upperChars;
    kebabToSnake = replaceStrings [ kebabSep ] [ snakeSep ];

    snakeToCamel = replaceStrings snakeChars upperChars;
    snakeToKebab = replaceStrings [ snakeSep ] [ kebabSep ];
  };

  lines = split "\n";

  repeat = n: str:
    concat (replicate n str);

  string = {
    concat = lib.concatStrings;

    find = find' false;

    intersperse = builtins.concatStringsSep;

    length = builtins.stringLength;

    optional = lib.optionalString;

    rfind = find' true;

    split = lib.splitString;

    splitAt = index:
      let
        index' = if negative index then 0 else index;
      in
      str:
        pair
          (substring 0 index' str)
          (substring index' int.MAX str);

    unsafeDiscardContext = builtins.unsafeDiscardStringContext;
  };

  uncommands = intersperse ";";

  unelements = intersperse ",";

  unlines = intersperse "\n";

  unwords = intersperse " ";

  words = split " ";
}
