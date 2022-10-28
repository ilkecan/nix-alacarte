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
    fromListFn = listFn: fn: attrs:
      listFn (name: fn name attrs.${name}) (self.names attrs);

    mkFold = fold:
      op:
        fn.compose [ self.zipWith fn.const (fold op) ];
  };
}
