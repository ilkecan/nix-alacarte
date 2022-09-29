{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    mkAssert
    mkThrow
  ;

  args = { scope = [ "nix-alacarte" ]; };
in

{
  assert' = mkAssert args;
  throw = mkThrow args;
}
