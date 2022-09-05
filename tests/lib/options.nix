{
  dnm,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    mkOption
    mkOptionType
    toList
    types
  ;

  inherit (nix-alacarte.options)
    internal
    public
    readOnly
    writable

    default
    unsetDefault

    apply
    unsetApply

    addCheck

    between
    coerceTo
    lambda
    list
    nonEmptyList
    optional
    optionalList
    set
    unique
  ;

  inherit (dnm)
    assertAll
    assertEqual
    assertFalse
    assertTrue
  ;

  emptyOption = mkOption { type = types.unspecified; };
in

{
  internal = assertTrue (internal emptyOption).internal;
  public = assertFalse (public emptyOption).internal;

  readOnly = assertTrue (readOnly emptyOption).readOnly;
  writable = assertFalse (writable emptyOption).readOnly;

  default = assertEqual {
    actual = (default "some value" emptyOption).default;
    expected = "some value";
  };
  unsetDefault = assertFalse (unsetDefault (mkOption { default = "some other value"; }) ? default);

  apply = assertEqual {
    actual = (apply (x: x + 5) emptyOption).apply 4;
    expected = 9;
  };
  unsetApply = assertFalse (unsetApply (mkOption { apply = x: "some function"; }) ? apply);

  addCheck =
    let
      option = emptyOption;
      positive = addCheck (x: x > 0) emptyOption;
    in
    assertAll [
      (assertTrue (emptyOption.type.check 4))
      (assertTrue (emptyOption.type.check (-4)))
      (assertTrue (positive.type.check 4))
      (assertFalse (positive.type.check (-4)))
    ];

  between =
    let
      # [4,8]
      betweenFourAndEight = between 4 8 emptyOption;
    in
    {
      typeIsCorrect = assertEqual {
        actual = betweenFourAndEight.type.name;
        expected = "intBetween";
      };

      inInvernal = assertTrue (betweenFourAndEight.type.check 6);
      notInInterval = assertFalse (betweenFourAndEight.type.check 11);
    };

  coerceTo =
    let
      strWithoutEmptyValue = types.str;
      strWithEmptyValue = strWithoutEmptyValue // { emptyValue.value = ""; };
      pathOptionWithoutDefault = mkOption { type = types.path; };
      pathOptionWithDefault = pathOptionWithoutDefault // { default = "<some path>"; };
    in
    {
      typeIsCorrect = assertEqual {
        actual = (coerceTo types.unspecified lib.id emptyOption).type.name;
        expected = "coercedTo";
      };

      optionWithoutDefaultToTypeWithoutEmptyValue =
        dnm.assertFailure ((coerceTo strWithoutEmptyValue toString pathOptionWithoutDefault).default or throw "no default");

      optionWithoutDefaultToTypeWithEmptyValue = assertEqual {
        actual = (coerceTo strWithEmptyValue toString pathOptionWithoutDefault).default;
        expected = "";
      };

      optionWithDefaultToTypeWithoutEmptyValue = assertEqual {
        actual = (coerceTo strWithoutEmptyValue toString pathOptionWithDefault).default;
        expected = "<some path>";
      };

      optionWithDefaultToTypeWithEmptyValue = assertEqual {
        actual = (coerceTo strWithEmptyValue toString pathOptionWithDefault).default;
        expected = "<some path>";
      };
    };

  lambda =
    let
      intTypeWithoutEmptyValue = types.int;
      intTypeWithEmptyValue = intTypeWithoutEmptyValue // { emptyValue.value = 0; };

      intOptionWithoutDefaultAndWithoutEmptyValue = mkOption { type = intTypeWithoutEmptyValue; };
      intOptionWithoutDefaultAndWithEmptyValue = mkOption { type = intTypeWithEmptyValue; };
      intOptionWithDefaultAndWithoutEmptyValue = mkOption { type = intTypeWithoutEmptyValue; default = 4; };
      intOptionWithDefaultAndWithEmptyValue = mkOption { type = intTypeWithEmptyValue; default = 4; };
    in
    {
      typeIsCorrect = assertEqual {
        actual = (lambda emptyOption).type.name;
        expected = "functionTo";
      };

      optionWithoutDefaultAndTypeWithoutEmptyValue =
        dnm.assertFailure ((lambda intOptionWithoutDefaultAndWithoutEmptyValue).default or throw "no default" null);

      optionWithoutDefaultAndTypeWithEmptyValue = assertEqual {
        actual = (lambda intOptionWithoutDefaultAndWithEmptyValue).default null;
        expected = 0;
      };

      optionWithDefaultAndTypeWithoutEmptyValue = assertEqual {
        actual = (lambda intOptionWithDefaultAndWithoutEmptyValue).default null;
        expected = 4;
      };

      optionWithDefaultAndTypeWithEmptyValue = assertEqual {
        actual = (lambda intOptionWithDefaultAndWithEmptyValue).default null;
        expected = 4;
      };
    };

  list =
    let
      option = list (emptyOption // { apply = x: 2 * x; });
    in
    {
      typeIsCorrect = assertEqual {
        actual = option.type.name;
        expected = "listOf";
      };

      applyIsPropagated = assertEqual {
        actual = option.apply [ 2 3 5 ];
        expected = [ 4 6 10 ];
      };

      defaultIsEmptyList = assertEqual {
        actual = option.default;
        expected = [ ];
      };
    };

  nonEmptyList =
    let
      option = nonEmptyList (emptyOption // { default = 23; });
    in
    {
      typeIsCorrect = assertEqual {
        actual = option.type.name;
        expected = "listOf";
      };

      emptyListIsNotAccepted = assertFalse (option.type.check [ ]);
      nonEmptyListIsAccepted = assertTrue (option.type.check [ 4 ]);
      defaultIsUnset = assertFalse (option ? default);
    };

  optional =
    let
      optionalFloat = optional (mkOption { type = types.float; });
    in
    {
      nullIsAccepted = assertTrue (optionalFloat.type.check null);
      originalTypeIsAccepted = assertTrue (optionalFloat.type.check 4.5);
      otherTypesAreRejected = assertFalse (optionalFloat.type.check 21);
    };

  optionalList =
    let
      strWithoutDefault = mkOption { type = types.str; };
      strWithDefault = strWithoutDefault // { default = "hey there"; };
    in
    {
      typeIsCorrect = assertEqual {
        actual = (optionalList emptyOption).type.name;
        expected = "coercedTo";
      };

      optionWithoutDefault = assertEqual {
        actual = (optionalList strWithoutDefault).default;
        expected = [ ];
      };

      optionWithDefault = assertEqual {
        actual = (optionalList strWithDefault).default;
        expected = "hey there";
      };
    };

  set =
    let
      option = set (emptyOption // { apply = x: x + "s"; });
    in
    {
      typeIsCorrect = assertEqual {
        actual = option.type.name;
        expected = "attrsOf";
      };

      applyIsPropagated = assertEqual {
        actual = option.apply { a = "apple"; o = "orange"; };
        expected = { a = "apples"; o = "oranges"; };
      };

      defaultIsEmptySet = assertEqual {
        actual = option.default;
        expected = { };
      };
    };

  unique = assertEqual {
    actual = (unique emptyOption).type.name;
    expected = "uniq";
  };
}
