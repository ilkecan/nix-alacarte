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
    negate
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

  negate = {
    integer = {
      zero = assertEqual {
        actual = negate 0;
        expected = 0;
      };

      positive = assertEqual {
        actual = negate 23;
        expected = -23;
      };

      negative = assertEqual {
        actual = negate (-23);
        expected = 23;
      };
    };

    float = {
      zero = assertEqual {
        actual = negate 0.0;
        expected = 0.0;
      };

      positive = assertEqual {
        actual = negate 23.7;
        expected = -23.7;
      };

      negative = assertEqual {
        actual = negate (-23.7);
        expected = 23.7;
      };
    };
  };

  odd = {
    true = assertTrue odd 5;
    false = assertFalse odd 4;
  };
}
