{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    float
    list
    type
  ;

  self = float;
in

{
  isFinite = number:
    !(self.isNan number || list.elem number [ self.INFINITY self.NEG_INFINITY ]);

  isNan = number:
    type.isFloat number && number != number;

  toString = lib.strings.floatToString;
}
