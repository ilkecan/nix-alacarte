{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    singleton
    tuple
  ;
in

{
  __functor = _:
    x:
      { "fst" = x; };

  curry = f: x:
    f (singleton x);

  uncurry = f: { fst }:
    f fst;

  ## inherits
  inherit (tuple)
    fst
    join
  ;
}
