{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    increment
    decrement
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  increment = assertEqual {
    actual = increment 12;
    expected = 13;
  };

  decrement = assertEqual {
    actual = decrement 23;
    expected = 22;
  };
}
