{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    lowerChars
    max
  ;

  inherit (nix-alacarte)
    fn
    list
    range1
    str
    type
  ;

  inherit (str)
    length
    optional
    slice
  ;

  inherit (nix-alacarte.internal)
    throw
  ;

  inherit (nix-alacarte.internal.str)
    kebabSep
    sliceUnsafe
    snakeSep
  ;
in

{
  str =
    let
      throw' = throw.appendScope "str";
    in
    {
      find' = reverse:
        let
          throw'' = throw'.appendScope "${optional reverse "r"}find";
        in
        pattern:
          let
            patternType = type.of pattern;
            patternLength = length pattern;
            searcher =
              {
                string = str: i:
                  slice i (i + patternLength) str == pattern;
                lambda = pattern;
              }.${patternType} or (throw'' [ "string" "lambda" ] "`type.of pattern`" patternType);
          in
          str:
            fn.pipe str [
              length
              range1
              (if reverse then list.reverse else fn.id)
              (list.find (searcher str))
            ];

      kebabChars = map (c: "${kebabSep}${c}") lowerChars;

      kebabSep = "-";

      slice' =
        {
          normalizeNegativeIndex ? fn.const fn.id,
        }:
        start: end: string:
          let
            length' = length string;
            normalizeNegativeIndex' = normalizeNegativeIndex length';
            start' = fn.pipe start [
              normalizeNegativeIndex'
              (max 0)
            ];
            end' = fn.pipe end [
              normalizeNegativeIndex'
              (max start')
            ];
          in
          sliceUnsafe start' end' string;

      sliceUnsafe = start: end:
        builtins.substring start (end - start);

      snakeChars = map (c: "${snakeSep}${c}") lowerChars;

      snakeSep = "_";
    };
}
