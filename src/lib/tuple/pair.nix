{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    pair
    tuple
  ;
in

{
  __functor = _:
    x: y:
      { "fst" = x; "snd" = y; };

  curry = f: x: y:
    f (pair x y);

  swap = { fst, snd }:
    pair snd fst;

  uncurry = f: { fst, snd }:
    f fst snd;

  ## inherits
  inherit (tuple)
    fst
    join
    snd
  ;
}
