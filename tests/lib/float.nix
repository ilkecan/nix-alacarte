{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte.float)
    toString
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  toString = assertEqual {
    actual = toString (-40.123);
    expected = "-40.123000";
  };
}
