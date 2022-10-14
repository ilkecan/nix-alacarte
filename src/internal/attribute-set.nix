{
  nix-alacarte,
  ...
}:

let
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
        fn.compose [ self.zipWith fn.const (fold op) ];
  };
}
