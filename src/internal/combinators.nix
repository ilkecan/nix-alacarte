{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    combinators
    fn
  ;
in

{
  booleanCombinator = f:
    combinators.mkCombinator (f fn.id);
}
