{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    add
  ;

  inherit (nix-alacarte.tuple)
    pair
  ;

  inherit (pair)
    curry
    fst
    swap
    uncurry
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  curry = assertEqual {
    actual = curry fst 1 2;
    expected = 1;
  };

  pair = assertEqual {
    actual = pair 2.4 true;
    expected = { "fst" = 2.4; "snd" = true; };
  };

  uncurry = assertEqual {
    actual = uncurry add (pair 4.9 2);
    expected = 6.9;
  };

  swap = assertEqual {
    actual = swap (pair 23 false);
    expected = { "fst" = false; "snd" = 23; };
  };
}
