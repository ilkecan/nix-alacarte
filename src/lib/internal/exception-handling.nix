{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    mkAssertion
    mkThrow
  ;

  args = { scope = [ "nix-alacarte" ]; };
in

{
  assertion = mkAssertion args;
  throw = mkThrow args;
}
