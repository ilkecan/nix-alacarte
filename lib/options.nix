{
  lib,
  ...
}:

let
  inherit (lib)
    types
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

    apply = f: option:
      option // { apply = f; };
    default = value: option:
      option // { default = value; };
    internal = option:
      option // { internal = true; };
    optional = option:
      option // {
        default = option.default or null;
        type = types.nullOr option.type;
      };
    readOnly = option:
      option // { readOnly = true; };

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

    ## listOf
    mkListOf = type:
      mkOption' (types.listOf type) [ ];
    listOfInt = mkListOf types.int;
    listOfStr = mkListOf types.str;
    listOfPackages = mkListOf types.package;

    ## attrsOf
    mkAttrsOf = type:
      mkOption' (types.attrsOf type) { };
    attrsOfInt = mkAttrsOf types.int;
    attrsOfStr = mkAttrsOf types.str;
    settings = mkAttrsOf settingsValue;
  };
}
