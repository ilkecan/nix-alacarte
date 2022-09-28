{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    abs
    decrement
    even
    increment
    negate
    negative
    odd
    positive
  ;

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  abs = {
    integer = {
      negative = assertEqual {
        actual = abs (-4);
        expected = 4;
      };

      zero = assertEqual {
        actual = abs 0;
        expected = 0;
      };

      positive = assertEqual {
        actual = abs 4;
        expected = 4;
      };
    };

    float = {
      negative = assertEqual {
        actual = abs (-4.7);
        expected = 4.7;
      };

      zero = assertEqual {
        actual = abs 0.0;
        expected = 0.0;
      };

      positive = assertEqual {
        actual = abs 4.19;
        expected = 4.19;
      };
    };
  };

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

  negative = {
    integer = {
      negative = assertTrue negative (-4);
      zero = assertFalse negative 0;
      positive = assertFalse negative 48;
    };

    float = {
      negative = assertTrue negative (-4.4);
      zero = assertFalse negative 0.0;
      positive = assertFalse negative 48.9;
    };
  };

  odd = {
    true = assertTrue odd 5;
    false = assertFalse odd 4;
  };

  positive = {
    integer = {
      negative = assertFalse positive (-4);
      zero = assertFalse positive 0;
      positive = assertTrue positive 48;
    };

    float = {
      negative = assertFalse positive (-4.4);
      zero = assertFalse positive 0.0;
      positive = assertTrue positive 48.9;
    };
  };
}
