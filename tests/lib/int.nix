{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    int
  ;

  inherit (int)
    toFloat
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  toFloat = {
    positive = assertEqual {
      actual = toFloat 42;
      expected = 42;
    };

    negative = assertEqual {
      actual = toFloat (-23);
      expected = -23.0;
    };
  };
}
