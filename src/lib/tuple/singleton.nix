{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    singleton
    tuple
  ;

  inherit (singleton)
    fst
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
