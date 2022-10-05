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
    id
    max
    min
    pipe
  ;

  inherit (nix-alacarte)
    list
    negative
    range3
  ;

  inherit (nix-alacarte.internal.list)
    sliceUnsafe
  ;

  self = list;
in

{
  list = {
    slice' =
      {
        normalizeNegativeIndex ? const id,
        step ? 1,
      }:
      start: end: list:
        let
          length = self.length list;
          normalizeNegativeIndex' = normalizeNegativeIndex length;
          start' = pipe start [
            normalizeNegativeIndex'
            (max 0)
          ];
          end' = pipe end [
            normalizeNegativeIndex'
            (min length)
          ];
        in
        sliceUnsafe { inherit step; } start' end' list;

    sliceUnsafe =
      {
        step ? 1,
      }:
      start: end: list:
        map (elemAt list) (range3 step start end);
  };

  normalizeNegativeIndex = length: index:
    if negative index
      then length + index
      else index;
}
