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

  settingsValue = with types; oneOf [
    bool
    int
    float
    str
    path
    (attrsOf settingsValue)
    (listOf settingsValue)
  ];
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

    ## bool
    bool = mkOption types.bool;
    enable = mkOption' types.bool false;
    disable = mkOption' types.bool true;

    ## package
    package = mkOption types.package;

    ## settings
    format = format:
      mkOption' format { };

    ## lines
    lines = mkOption' types.lines "";

    ## str
    str = mkOption types.str;

    ## int
    int = mkOption types.int;

    ## path
    path = mkOption types.path;

    ## enum
    enum = values:
      mkOption (types.enum values);

    ## submodule
    submodule = module:
      mkOption' (types.submodule module) { };

    ## attrsOf
    mkAttrsOf = type:
      mkOption' (types.attrsOf type) { };
    attrsOfInt = mkAttrsOf types.int;
    attrsOfStr = mkAttrsOf types.str;
    settings = mkAttrsOf settingsValue;
  };
}
