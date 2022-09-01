{
  alacarte,
  dnm,
  ...
}:

let
  inherit (alacarte)
    boolToInt
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  boolToInt = {
    true = assertEqual {
      actual = boolToInt true;
      expected = 1;
    };

    false = assertEqual {
      actual = boolToInt false;
      expected = 0;
    };
  };
}
