{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    type
  ;

  inherit (type)
    isAttrs
    isBool
    isFloat
    isFn
    isInt
    isLambda
    isList
    isNull
    isPath
    isStr
    of
  ;
    

  inherit (dnm)
    assertEqual
    assertFalse
    assertTrue
  ;
in

{
  isAttrs = {
    attribute_set = assertTrue isAttrs { };
    not_an_attribute_set = assertFalse isAttrs true;
  };

  isBool = {
    boolean = assertTrue isBool true;
    not_a_boolean = assertFalse isBool 4.9;
  };

  isFloat = {
    float = assertTrue isFloat 4.9;
    not_a_float = assertFalse isFloat { __functor = _: x: 2 * x; };
  };

  isFn = {
    functor = assertTrue isFn { __functor = _: x: 2 * x; };
    lambda = assertTrue isFn (x: x + 2);
    not_a_function = assertFalse isFn 4;
  };

  isInt = {
    integer = assertTrue isInt 4;
    not_an_integer = assertFalse isInt (x: x + 2);
  };

  isLambda = {
    lambda = assertTrue isLambda (x: x + 2);
    not_a_lambda = assertFalse isLambda [ ];
  };

  isList = {
    list = assertTrue isList [ ];
    not_a_list = assertFalse isList null;
  };

  isNull = {
    null = assertTrue isNull null;
    not_a_null = assertFalse isNull ./.;
  };

  isPath = {
    path = assertTrue isPath ./.;
    not_a_path = assertFalse isPath "";
  };

  isStr = {
    string = assertTrue isStr "";
    not_a_string = assertFalse isStr { };
  };

  of = {
    bool = assertEqual {
      actual = of true;
      expected = "bool";
    };

    float = assertEqual {
      actual = of 2.4;
      expected = "float";
    };

    int = assertEqual {
      actual = of 8;
      expected = "int";
    };

    lambda = assertEqual {
      actual = of (x: x / 4);
      expected = "lambda";
    };

    list = assertEqual {
      actual = of [ ];
      expected = "list";
    };

    null = assertEqual {
      actual = of null;
      expected = "null";
    };

    path = assertEqual {
      actual = of ./.;
      expected = "path";
    };

    set = assertEqual {
      actual = of { };
      expected = "set";
    };

    string = assertEqual {
      actual = of "abc";
      expected = "string";
    };
  };
}
