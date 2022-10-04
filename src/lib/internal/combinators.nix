{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    id
  ;

  inherit (nix-alacarte)
    combinators
  ;
in

{
  booleanCombinator = f:
    combinators.mkCombinator (f id);
}
