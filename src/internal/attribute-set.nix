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
    attrs
    fn
  ;

  self = attrs;
in
{
  attrs = {
    mkFold = fold:
      op:
        fn.compose [ self.zipWith const (fold op) ];
  };
}
