{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte.tuple)
    singleton
  ;

  inherit (singleton)
    curry
    fst
    uncurry
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  curry = assertEqual {
    actual = curry fst 1;
    expected = 1;
  };

  pair = assertEqual {
    actual = singleton "svh";
    expected = { "fst" = "svh"; };
  };

  uncurry = assertEqual {
    actual = uncurry toString (singleton 42);
    expected = "42";
  };
}
