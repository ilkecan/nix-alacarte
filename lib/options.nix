{
  lib,
  nix-utils,
  internal,
  ...
}:

let
  inherit (lib)
    const
    genAttrs
    getExe
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
      option // {
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
      option // {
        default = { };
        type = types.attrsOf option.type;
      };
  };

  typeNames = [
    "bool"
    "float"
    "int"
    "package"
    "path"
    "str"
  ];

  optionFunctions = {
    option = type:
      pipe (lib.mkOption { inherit type; });

    # bool
    enable = withDefault [ (default false) ]
      mkBool;
    disable = withDefault [ (default true) ]
      mkBool;

    # str
    exe = drv:
      withDefault [ (default (getExe drv)) readOnly ]
        mkStr;
    strMatching = pattern:
      mkOption (types.strMatching pattern);

    enum = values:
      mkOption (types.enum values);
    envVars = fs:
      withDefault [ set ]
        (mkOption (types.coercibleToString fs));
    format = format:
      withDefault [ (default { }) ]
        (mkOption format.type);
    lines =
      withDefault [ (default "") ]
        (mkOption types.lines);
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
