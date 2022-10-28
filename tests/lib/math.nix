{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    math
  ;

  inherit (math)
    pow
  ;

  inherit (dnm)
    assertEqual
    assertFailure
  ;
in

{
  pow = {
    base_integer_exponent_integer = {
      base_positive_exponent_posive = assertEqual {
        actual = pow 2 4;
        expected = 16;
      };

      base_positive_exponent_zero = assertEqual {
        actual = pow 2 0;
        expected = 1;
      };

      base_positive_exponent_negative= assertEqual {
        actual = pow 2 (-3);
        expected = 0.125;
      };

      base_zero_exponent_posive = assertEqual {
        actual = pow 0 4;
        expected = 0;
      };

      base_zero_exponent_zero = assertEqual {
        actual = pow 0 0;
        expected = 1;
      };

      base_zero_exponent_negative = assertFailure pow 0 (-3);

      base_negative_exponent_posive = assertEqual {
        actual = pow (-3) 4;
        expected = 81;
      };

      base_negative_exponent_zero = assertEqual {
        actual = pow (-3) 0;
        expected = 1;
      };

      base_negative_exponent_negative = assertEqual {
        actual = pow (-2) (-2);
        expected = 0.25;
      };
    };
  };
}
