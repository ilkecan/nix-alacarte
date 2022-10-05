{
  lib,
  nix-alacarte,
  ...
}:

{
  generators = lib.generators // { alacarte = nix-alacarte.generators; };
}
