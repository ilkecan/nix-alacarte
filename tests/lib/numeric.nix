{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    abs
    add
    decrement
    div
    div'
    even
    increment
    mod
    mod'
    mul
    negate
    negative
    odd
    positive
    sub
    sub'
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

  add = {
    integer = assertEqual {
      actual = add 4 12;
      expected = 16;
    };

    float = assertEqual {
      actual = add 4.2 11.8;
      expected = 16.0;
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

  div = assertEqual {
    actual = div 13 7;
    expected = 1;
  };

  div' = assertEqual {
    actual = div' 2 5;
    expected = 2;
  };

  even = {
    positive = {
      true = assertTrue even 4;
      false = assertFalse even 3;
    };

    zero = assertTrue even 0;

    negative = {
      true = assertTrue even (-4);
      false = assertFalse even (-3);
    };
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

  mod = assertEqual {
    actual = mod 13 7;
    expected = 6;
  };

  mod' = assertEqual {
    actual = mod' 2 5;
    expected = 1;
  };

  mul = assertEqual {
    actual = mul (-4) 9;
    expected = -36;
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
    positive = {
      true = assertTrue odd 5;
      false = assertFalse odd 4;
    };

    zero = assertFalse odd 0;

    negative = {
      true = assertTrue odd (-5);
      false = assertFalse odd (-4);
    };
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

  sub = {
    integer = assertEqual {
      actual = sub 5 2;
      expected = 3;
    };

    float = assertEqual {
      actual = sub 123.239 22.92;
      expected = 100.319;
    };
  };

  sub' = {
    integer = assertEqual {
      actual = sub' 4 8;
      expected = 4;
    };

    float = assertEqual {
      actual = sub' 3.50 23.28;
      expected = 19.78;
    };
  };
}
