{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fst
    snd
  ;

  inherit (dnm)
    assertEqual
    assertFailure
  ;
in

{
  fst = {
    attr_missing = assertFailure fst { "1" = 49; };
    attr_not_missing = assertEqual {
      actual = fst { "0" = 24; };
      expected = 24;
    };
  };

  snd = {
    attr_missing = assertFailure snd { "0" = 8; };
    attr_not_missing = assertEqual {
      actual = snd { "1" = 54; };
      expected = 54;
    };
  };
}
