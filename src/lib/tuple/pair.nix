{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fst
    pair
    snd
  ;
in

{
  __functor = _:
    x: y:
      { "0" = x; "1" = y; };

  curry = f: x: y:
    f (pair x y);

  uncurry = f: pair':
    f (fst pair') (snd pair');
}
