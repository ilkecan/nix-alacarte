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

  };
}
