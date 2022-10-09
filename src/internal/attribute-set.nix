{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    const
  ;

  inherit (nix-alacarte)
    compose
    attrs
  ;

  self = attrs;
in
{
  attrs = {
    mkFold = fold:
      op:
        compose [ self.zipWith const (fold op) ];
  };
}
