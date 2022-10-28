{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    float
    list
  ;

  self = float;
in

{
  isFinite = number:
    number == number && !list.elem number [ self.INFINITY self.NEG_INFINITY ];

  toString = lib.strings.floatToString;
}
