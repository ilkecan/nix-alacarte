{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    decrement
    even
    increment
    odd
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  decrement = {
    integer = assertEqual {
      actual = decrement 23;
      expected = 22;
    };

    float = assertEqual {
      actual = decrement 24.23;
      expected = 23.23;
    };
  };

  even = {
    true = assertTrue even 4;
    false = assertFalse even 3;
  };

  increment = {
    integer = assertEqual {
      actual = increment 12;
      expected = 13;
    };

    float = assertEqual {
      actual = increment 12.74;
      expected = 13.74;
    };
  };

  odd = {
    true = assertTrue odd 5;
    false = assertFalse odd 4;
  };
}
