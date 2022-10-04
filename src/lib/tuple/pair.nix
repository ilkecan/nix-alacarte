{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    pair
    tuple
  ;

  inherit (pair)
    fst
    snd
  ;
in

{
  __functor = _:
    x: y:
      { "fst" = x; "snd" = y; };

  curry = f: x: y:
    f (pair x y);

  swap = pair':
    pair (snd pair') (fst pair');

  uncurry = f: pair':
    f (fst pair') (snd pair');

  ## inherits
  inherit (tuple)
    fst
    join
    snd
  ;
}
