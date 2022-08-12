{
  lib,
  nix-utils,
  ...
}:

let
  inherit (lib)
    types
  ;

  inherit (nix-utils)
    setAttr
  ;
in

{
  options = rec {
    mkOption = type:
      lib.mkOption { inherit type; };
    mkOption' = type: default:
    lib.mkOption { inherit type default; };

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
        default = option.default or [ ];
        type = types.listOf option.type;
      };
    optional = option:
      option // {
        default = option.default or null;
        type = types.nullOr option.type;
      };
    set = option:
      option // {
        default = option.default or { };
        type = types.attrsOf option.type;
      };

    bool = mkOption types.bool;
    enable = mkOption' types.bool false;
    disable = mkOption' types.bool true;

    package = mkOption types.package;

    format = format:
      mkOption' format { };

    lines = mkOption' types.lines "";

    str = mkOption types.str;

    int = mkOption types.int;

    path = mkOption types.path;

    enum = values:
      mkOption (types.enum values);

    submodule = module:
      mkOption' (types.submodule module) { };
  };
}
