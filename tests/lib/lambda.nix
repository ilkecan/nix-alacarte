{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fn
  ;

  inherit (fn)
    call
    callWith
    compose
    flip
    id
    pipe
    pipe'
    ternary
    ternary'
    toAttrs
  ;

  inherit (dnm)
    assertAll
    assertEqual
    assertFailure
    assertTrue
  ;

  double = x: 2 * x;
  addFive = x: x + 5;
  subtractNine = x: x - 9;
in

{
  call = assertEqual {
    actual = call (n: n > 2) 4;
    expected = true;
  };

  callWith = assertEqual {
    actual = callWith 5 (n: n + 10);
    expected = 15;
  };

  compose = assertEqual {
    actual = compose [ double addFive subtractNine ] 2;
    expected = -4;
  };

  flip = assertEqual {
    actual = flip (x: y: x - y) 10 5;
    expected = -5;
  };

  id = assertEqual {
    actual = id 24.4;
    expected = 24.4;
  };

  pipe = {
    empty = assertEqual {
      actual = pipe 5 [ ];
      expected = 5;
    };

    non_empty = assertEqual {
      actual = pipe 5 [ double subtractNine addFive ];
      expected = 6;
    };
  };

  pipe' = {
    empty = assertEqual {
      actual = pipe' [ ] 5;
      expected = 5;
    };

    non_empty = assertEqual {
      actual = pipe' [ double subtractNine addFive ] 5;
      expected = 6;
    };
  };

  ternary = {
    first_expr = assertEqual {
      actual = ternary (4 < 1) "four" "one";
      expected = "one";
    };

    second_expr = assertEqual {
      actual = ternary (4 < 9) "four" "nine";
      expected = "four";
    };
  };

  ternary' = {
    first_expr = assertEqual {
      actual = ternary' "four" "one" (4 < 1);
      expected = "one";
    };

    second_expr = assertEqual {
      actual = ternary' "four" "nine" (4 < 9);
      expected = "four";
    };
  };

  toAttrs = {
    non_function = assertFailure toAttrs 24;

    lambda =
      let
        x = { x, y ? 0 }: x + y;
        y = toAttrs x;
        args = { x = 3; y = 5; };
      in
      assertAll [
        (assertTrue (y ? __functor))
        (assertEqual {
          actual = y.__functionArgs;
          expected = { x = false; y = true; };
        })
        (assertTrue (x args == y args))
      ];

    attribute_set =
      let
        x = { __functor = _: x: y: x + y; };
        y = toAttrs x;
        arg1 = 3;
        arg2 = 5;
      in
      assertAll [
        (assertTrue (y ? __functor))
        (assertEqual {
          actual = y.__functionArgs;
          expected = { };
        })
        (assertTrue (x arg1 arg2 == y arg1 arg2))
      ];
  };
}
