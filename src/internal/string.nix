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
    pipe
  ;

  inherit (nix-alacarte)
    list
    range1
    str
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
            patternType = typeOf pattern;
            patternLength = length pattern;
            searcher =
              {
                string = str: i:
                  slice i (i + patternLength) str == pattern;
                lambda = pattern;
              }.${patternType} or (throw'' [ "string" "lambda" ] "`typeOf pattern`" patternType);
          in
          str:
            pipe str [
              length
              range1
              (if reverse then list.reverse else id)
              (list.find (searcher str))
            ];

      kebabChars = map (c: "${kebabSep}${c}") lowerChars;

      kebabSep = "-";

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

      sliceUnsafe = start: end:
        builtins.substring start (end - start);

      snakeChars = map (c: "${snakeSep}${c}") lowerChars;

      snakeSep = "_";
    };
}