{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    optionalValue
  ;

  inherit (dnm)
    assertEqual
    assertNull
  ;
in

{
  optionalValue = {
    true = assertEqual {
      actual = optionalValue true 4;
      expected = 4;
    };

    false = assertNull optionalValue false 23;
  };
}
