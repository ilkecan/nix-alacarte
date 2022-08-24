{
  lib,
  nix-utils,
  internal,
  ...
}:

let
  inherit (builtins)
    mapAttrs
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
    default
    mkBool
    mkOption
    mkStr
    readOnly
    set
  ;

  inherit (internal.options)
    generateOptions
    withDefault
  ;

  types = lib.types // nix-utils.types;

  composerFunctions = {
    apply = setAttr "apply";
    default = setAttr "default";
    internal = setAttr "internal" true;
    readOnly = setAttr "readOnly" true;

    addCheck = check: option:
      setAttr "type" (types.addCheck option.type check) option;
    between = lowest: highest:
      setAttr "type" (types.ints.between lowest highest);

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
    optional = option:
      option // {
        default = null;
        type = types.nullOr option.type;
      };
    optionalList = option:
      option // {
        type = types.coercedTo option.type toList (types.listOf option.type);
      };
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

    envVars = fs:
      withDefault [ set ]
        (mkOption (types.coercibleToString fs));
    format = format:
      withDefault [ (default { }) ]
        mkOption format.type;
    lines =
      withDefault [ (default "") ]
        mkOption types.lines;
    settings =
      withDefault [ (default { }) ]
        (mkOption types.genericValue);
    submodule = module:
      withDefault [ (default { }) ]
        (mkOption (types.submodule module));
  } // genAttrs typeNames (name: mkOption types.${name});
in

{
  options = composerFunctions // generateOptions optionFunctions;
}
