{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    negative
  ;
in

{
  normalizeNegativeIndex = length: index:
    if negative index
      then length + index
      else index;
}
