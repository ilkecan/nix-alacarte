{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte.tuple)
    unit
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  unit = assertEqual {
    actual = unit;
    expected = { };
  };
}
