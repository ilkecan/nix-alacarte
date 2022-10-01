{
  dnm,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    mkOption
    types
  ;

  inherit (nix-alacarte.options)
    internal
    public
    readOnly
    writable

    default
    required

    apply
    unsetApply

    addCheck

    attrs
    between
    coerceTo
    lambda
    list
    nonEmptyList
    optional
    optionalList
    unique
  ;

  inherit (dnm)
    assertAll
    assertEqual
    assertFailure
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
  required = assertFalse (required (mkOption { default = "some other value"; }) ? default);

  apply = assertEqual {
    actual = (apply (x: x + 5) emptyOption).apply 4;
    expected = 9;
  };
  unsetApply = assertFalse (unsetApply (mkOption { apply = _: "some function"; }) ? apply);

  addCheck =
    let
      positive = addCheck (x: x > 0) emptyOption;
    in
    assertAll [
      (assertTrue emptyOption.type.check 4)
      (assertTrue emptyOption.type.check (-4))
      (assertTrue positive.type.check 4)
      (assertFalse positive.type.check (-4))
    ];

  attrs =
    let
      option = attrs (emptyOption // { apply = x: x + "s"; });
    in
    {
      type_is_correct = assertEqual {
        actual = option.type.name;
        expected = "attrsOf";
      };

      apply_is_propagated = assertEqual {
        actual = option.apply { a = "apple"; o = "orange"; };
        expected = { a = "apples"; o = "oranges"; };
      };

      default_is_empty_set = assertEqual {
        actual = option.default;
        expected = { };
      };
    };

  between =
    let
      # [4,8]
      betweenFourAndEight = between 4 8 emptyOption;
    in
    {
      type_is_correct = assertEqual {
        actual = betweenFourAndEight.type.name;
        expected = "intBetween";
      };

      in_invernal = assertTrue betweenFourAndEight.type.check 6;
      not_in_interval = assertFalse betweenFourAndEight.type.check 11;
    };

  coerceTo =
    let
      strWithoutEmptyValue = types.str;
      strWithEmptyValue = strWithoutEmptyValue // { emptyValue.value = ""; };
      pathOptionWithoutDefault = mkOption { type = types.path; };
      pathOptionWithDefault = pathOptionWithoutDefault // { default = "<some path>"; };
    in
    {
      type_is_correct = assertEqual {
        actual = (coerceTo types.unspecified lib.id emptyOption).type.name;
        expected = "coercedTo";
      };

      option_without_default_to_type_without_empty_value =
        assertFailure (coerceTo strWithoutEmptyValue toString pathOptionWithoutDefault).default or throw "no default";

      option_without_default_to_type_with_empty_value = assertEqual {
        actual = (coerceTo strWithEmptyValue toString pathOptionWithoutDefault).default;
        expected = "";
      };

      option_with_default_to_type_without_empty_value = assertEqual {
        actual = (coerceTo strWithoutEmptyValue toString pathOptionWithDefault).default;
        expected = "<some path>";
      };

      option_with_default_to_type_with_empty_value = assertEqual {
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
      type_is_correct = assertEqual {
        actual = (lambda emptyOption).type.name;
        expected = "functionTo";
      };

      option_without_default_and_type_without_empty_value =
        assertFailure (lambda intOptionWithoutDefaultAndWithoutEmptyValue).default or throw "no default" null;

      option_without_default_and_type_with_empty_value = assertEqual {
        actual = (lambda intOptionWithoutDefaultAndWithEmptyValue).default null;
        expected = 0;
      };

      option_with_default_and_type_without_empty_value = assertEqual {
        actual = (lambda intOptionWithDefaultAndWithoutEmptyValue).default null;
        expected = 4;
      };

      option_with_default_and_type_with_empty_value = assertEqual {
        actual = (lambda intOptionWithDefaultAndWithEmptyValue).default null;
        expected = 4;
      };
    };

  list =
    let
      option = list (emptyOption // { apply = x: 2 * x; });
    in
    {
      type_is_correct = assertEqual {
        actual = option.type.name;
        expected = "listOf";
      };

      apply_is_propagated = assertEqual {
        actual = option.apply [ 2 3 5 ];
        expected = [ 4 6 10 ];
      };

      default_is_empty_list = assertEqual {
        actual = option.default;
        expected = [ ];
      };
    };

  nonEmptyList =
    let
      option = nonEmptyList (emptyOption // { default = 23; });
    in
    {
      type_is_correct = assertEqual {
        actual = option.type.name;
        expected = "listOf";
      };

      empty_list_is_not_accepted = assertFalse option.type.check [ ];
      non_empty_list_is_accepted = assertTrue option.type.check [ 4 ];
      default_is_unset = assertFalse (option ? default);
    };

  optional =
    let
      optionalFloat = optional (mkOption { type = types.float; });
    in
    {
      null_is_accepted = assertTrue optionalFloat.type.check null;
      original_type_is_accepted = assertTrue optionalFloat.type.check 4.5;
      other_types_are_rejected = assertFalse optionalFloat.type.check 21;
    };

  optionalList =
    let
      strWithoutDefault = mkOption { type = types.str; };
      strWithDefault = strWithoutDefault // { default = "hey there"; };
    in
    {
      type_is_correct = assertEqual {
        actual = (optionalList emptyOption).type.name;
        expected = "coercedTo";
      };

      option_without_default = assertEqual {
        actual = (optionalList strWithoutDefault).default;
        expected = [ ];
      };

      option_with_default = assertEqual {
        actual = (optionalList strWithDefault).default;
        expected = "hey there";
      };
    };

  unique = assertEqual {
    actual = (unique emptyOption).type.name;
    expected = "uniq";
  };
}
