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

  inherit (attrs)
    zipWith
  ;
in
{
  attrs = {
    mkFold = fold:
      op:
        compose [ zipWith const (fold op) ];
  };
}
