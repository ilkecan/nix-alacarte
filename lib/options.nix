{
  lib,
  nix-utils,
  ...
}:

let
  inherit (lib)
    pipe
    types
  ;

  inherit (nix-utils)
    setAttr
  ;
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
    set = option:
      option // {
        default = { };
        type = types.attrsOf option.type;
      };
    ## end ##

    mkBool = mkOption types.bool;
    bool = mkBool [ ];
    enable = mkBool [ (default false) ];
    disable = mkBool [ (default true) ];

    mkFormat = format: fs:
      mkOption format ([ (default { }) ] ++ fs);
    format = format:
      mkFormat format [ ];

    mkPackage = mkOption types.package;
    package = mkPackage [ ];

    mkLines = fs:
      mkOption types.lines ([ (default "") ] ++ fs);
    lines = mkLines [ ];

    mkStr = mkOption types.str;
    str = mkStr [ ];

    mkInt = mkOption types.int;
    int = mkInt [ ];

    mkPath = mkOption types.path;
    path = mkPath [ ];

    mkEnum = values:
      mkOption (types.enum values);
    enum = values:
      mkEnum values [ ];

    mkSubmodule = module: fs:
      mkOption (types.submodule module) ([ (default { }) ] ++ fs);
    submodule = module:
      mkSubmodule module [ ];
  };
}
