{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fst
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

  uncurry = f: singleton':
    f (fst singleton');

  ## inherits
  inherit (tuple)
    fst
    join
  ;
}
