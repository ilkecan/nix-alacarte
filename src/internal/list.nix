{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elemAt
  ;

  inherit (lib)
    const
    max
    min
  ;

  inherit (nix-alacarte)
    fn
    list
    negative
    range3
  ;

  inherit (nix-alacarte.internal)
    assertion
  ;

  inherit (nix-alacarte.internal.list)
    sliceUnsafe
  ;

  self = list;
in

{
  list =
    let
      assertion' = assertion.appendScope "list";
    in
    {
      foldStartingWithHead = scope:
        let
          assertion'' = assertion'.appendScope scope;
        in
        f: list:
          assert assertion'' (self.notEmpty list) "empty list";
          let
            initial = self.head list;
          in
          self.foldl' f initial list;

      slice' =
        {
          normalizeNegativeIndex ? const fn.id,
          stride ? 1,
        }:
        start: end: list:
          let
            length = self.length list;
            normalizeNegativeIndex' = normalizeNegativeIndex length;
            start' = fn.pipe start [
              normalizeNegativeIndex'
              (max 0)
            ];
            end' = fn.pipe end [
              normalizeNegativeIndex'
              (min length)
            ];
          in
          sliceUnsafe { inherit stride; } start' end' list;

      sliceUnsafe =
        {
          stride ? 1,
        }:
        start: end: list:
          map (elemAt list) (range3 stride start end);
    };

  normalizeNegativeIndex = length: index:
    if negative index
      then length + index
      else index;
}
