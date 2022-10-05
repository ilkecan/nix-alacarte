{
  nix-alacarte,
  pkgs ? { },
  ...
}:

{
  formats = pkgs.formats // { alacarte = nix-alacarte.formats; };
}
