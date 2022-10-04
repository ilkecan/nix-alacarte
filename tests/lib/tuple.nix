{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte.tuple)
    fst
    join
    pair
    singleton
    snd
    unit
  ;

  inherit (dnm)
    assertEqual
    assertFailure
  ;
in

{
  fst = {
    attr_missing = assertFailure fst { "snd" = 49; };
    attr_not_missing = assertEqual {
      actual = fst { "fst" = 24; };
      expected = 24;
    };
  };

  join = {
    unit = assertEqual {
      actual = join "/" unit;
      expected = "";
    };

    singleton = assertEqual {
      actual = join ", "  (singleton 24);
      expected = "24";
    };

    pair = assertEqual {
      actual = join " - " (pair 23 48);
      expected = "23 - 48";
    };
  };

  snd = {
    attr_missing = assertFailure snd { "fst" = 8; };
    attr_not_missing = assertEqual {
      actual = snd { "snd" = 54; };
      expected = 54;
    };
  };
}
