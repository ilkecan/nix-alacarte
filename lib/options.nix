{
  lib,
  nix-utils,
  ...
}:

let
  inherit (lib)
    const
    getExe
    pipe
  ;

  inherit (nix-utils)
    optionalValue
    setAttr
  ;

  types = lib.types // nix-utils.types;

  withDefault = defaultFs: mkF: fs:
    mkF (defaultFs ++ fs);
in

{
  options = rec {
    mkOption = type:
      pipe (lib.mkOption { inherit type; });

    ## composer functions ##
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
        type = types.either option.type (types.listOf option.type);
      };
    set = option:
      option // {
        default = { };
        type = types.attrsOf option.type;
      };
    ## end ##

    mkBool = mkOption types.bool;
    bool = mkBool [ ];
    mkEnable =
      withDefault [ (default false) ]
        mkBool;
    enable = mkEnable [ ];
    mkDisable =
      withDefault [ (default true) ]
        mkBool;
    disable = mkDisable [ ];

    mkFormat = format:
      withDefault [ (default { }) ]
        (mkOption format.type);
    format = format:
      mkFormat format [ ];

    mkSettings =
      withDefault [ (default { }) ]
        (mkOption types.genericValue);
    settings = mkSettings [ ];

    mkPackage = mkOption types.package;
    package = mkPackage [ ];

    mkLines =
      withDefault [ (default "") ]
        (mkOption types.lines);
    lines = mkLines [ ];

    mkStr = mkOption types.str;
    str = mkStr [ ];
    exe = drv:
      mkStr [
        (default (getExe drv))
        readOnly
      ];

    mkInt = mkOption types.int;
    int = mkInt [ ];

    mkFloat = mkOption types.float;
    float = mkFloat [ ];

    mkPath = mkOption types.path;
    path = mkPath [ ];

    mkEnum = values:
      mkOption (types.enum values);
    enum = values:
      mkEnum values [ ];

    mkSubmodule = module:
      withDefault [ (default { }) ]
        (mkOption (types.submodule module));
    submodule = module:
      mkSubmodule module [ ];
  };
}
