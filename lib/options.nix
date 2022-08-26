{
  lib,
  nix-utils,
  internal,
  ...
}:

let
  inherit (builtins)
    mapAttrs
    removeAttrs
  ;

  inherit (lib)
    const
    genAttrs
    getExe
    isOptionType
    pipe
    toList
  ;

  inherit (nix-utils)
    optionalValue
    setAttr
  ;

  inherit (nix-utils.options)
    coerceTo
    default
    mkBool
    mkCoercibleToString
    mkGenericValue
    mkOption
    mkStr
    readOnly
    unsetDefault
    set
  ;

  inherit (internal.options)
    generateOptions
    withDefault
  ;

  types = lib.types // nix-utils.types;

  unsetAttr = name: set:
    removeAttrs set [ name ];

  composerFunctions = {
    apply = setAttr "apply";
    default = setAttr "default";
    internal = setAttr "internal" true;
    readOnly = setAttr "readOnly" true;

    unsetDefault = unsetAttr "default";

    addCheck = check: option:
      setAttr "type" (types.addCheck option.type check) option;
    between = lowest: highest:
      setAttr "type" (types.ints.between lowest highest);

    coerceTo = option: type: coerceFunc:
      let
        setDefault = !option ? default && type ? emptyValue;
      in
      option // {
        ${optionalValue (setDefault) "default"} = type.emptyValue.value;
        type = types.coercedTo option.type coerceFunc type;
      };
    lambda = option:
      let
        default = option.default or option.type.emptyValue.value or null;
      in
      option // {
        ${optionalValue (default != null) "default"} = const default;
        type = types.functionTo option.type;
      };
    list = option:
      let
        apply = option.apply or null;
      in
      option // {
        ${optionalValue (apply != null) "apply"} = map apply;
        default = [ ];
        type = types.listOf option.type;
      };
    nonEmptyList = option:
      unsetDefault option // {
        type = types.nonEmptyListOf option.type;
      };
    optional = option:
      option // {
        default = null;
        type = types.nullOr option.type;
      };
    optionalList = option:
      coerceTo option (types.listOf option.type) toList;
    set = option:
      let
        apply = option.apply or null;
      in
      option // {
        ${optionalValue (apply != null) "apply"} = mapAttrs (_: apply);
        default = { };
        type = types.attrsOf option.type;
      };
    unique = option:
      option // {
        type = types.uniq option.type;
      };
  };

  typeNames = [
    "bool"
    "enum"
    "float"
    "int"
    "package"
    "path"
    "shellPackage"
    "str"
    "strMatching"

    "coercibleToString"
    "genericValue"
  ];

  option = type:
    if isOptionType type then
      pipe (lib.mkOption { inherit type; })
    else
      arg:
        option (type arg)
    ;

  optionFunctions = {
    inherit option;

    # bool
    enable = withDefault [ (default false) ]
      mkBool;
    disable = withDefault [ (default true) ]
      mkBool;

    # str
    exe = drv:
      withDefault [ (default (getExe drv)) readOnly ]
        mkStr;

    envVars =
      withDefault [ set ]
        mkCoercibleToString;
    format = format:
      withDefault [ (default { }) ]
        mkOption format.type;
    lines =
      withDefault [ (default "") ]
        mkOption types.lines;
    settings =
      withDefault [ set ]
        mkGenericValue;
    submodule =
      withDefault [ (default { }) ]
        mkOption types.submodule;
  } // genAttrs typeNames (name: mkOption types.${name});
in

{
  options = composerFunctions // generateOptions optionFunctions;
}
