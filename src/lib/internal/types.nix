{
  lib,
  nix-alacarte,
  ...
}:

{
  types = lib.types // { alacarte = nix-alacarte.types; };
}
