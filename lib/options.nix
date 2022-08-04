{ lib, nix-utils }:

let
  inherit (builtins)
    concatStringsSep
    isList
    mapAttrs
  ;

  inherit (lib)
    types
  ;

  mkOption = type:
    lib.mkOption { inherit type; };

  mkOption' = type: default:
    lib.mkOption { inherit type default; };

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
    ## bool
    mkBool = mkOption' types.bool;
    bool = mkOption types.bool;
    enable = mkBool false;
    disable = mkBool true;

    ## package
    mkPackage = mkOption' types.package;

    ## settings
    mkSettings = format:
      mkOption' format { };

    ## lines
    lines = mkLines "";
    mkLines = mkOption' types.lines;

    ## str
    str = mkOption types.str;
    mkStr = mkOption' types.str;
    pathOrStr = mkOption (with types; coercedTo path toString str);

    ## int
    int = mkOption types.int;
    mkInt = mkOption' types.int;

    ## path
    path = mkOption types.path;
    mkPath = mkOption' types.path;

    ## enum
    enum = values:
      mkOption (types.enum values);
    mkEnum = values:
      mkOption' (types.enum values);

    ## submodule
    submodule = module:
      mkOption (types.submodule module);

    ## nullOr
    mkNullOr = type:
      mkOption' (types.nullOr type) null;
    nullOrBool = mkNullOr types.bool;
    nullOrInt = mkNullOr types.int;
    nullOrPath = mkNullOr types.path;
    nullOrStr = mkNullOr types.str;
    nullOrSubmodule = module:
      mkNullOr (types.submodule module);

    mkNullOr' = type:
      mkOption' (types.nullOr type);
    mkNullOrInt = mkNullOr' types.int;
    mkNullOrPath = mkNullOr' types.path;
    mkNullOrStr = mkNullOr' types.str;

    ## listOf
    mkListOf = type:
      mkOption' (types.listOf type) [ ];
    listOfInt = mkListOf types.int;
    listOfStr = mkListOf types.str;
    listOfPackages = mkListOf types.package;

    mkListOf' = type:
      mkOption' (types.listOf type);
    mkListOfInt = mkListOf' types.int;
    mkListOfStr = mkListOf' types.str;

    ## attrsOf
    mkAttrsOf = type:
      mkOption' (types.attrsOf type) { };
    attrsOfInt = mkAttrsOf types.int;
    attrsOfStr = mkAttrsOf types.str;
    settings = mkAttrsOf settingsValue;
    envVars = lib.mkOption {
      type = with types; attrsOf (either str (listOf str));
      apply = mapAttrs (_n: v: if isList v then concatStringsSep ":" v else v);
    };

    mkAttrsOf' = type:
      mkOption' (types.attrsOf type);
    mkAttrsOfInt = mkAttrsOf' types.int;
    mkAttrsOfStr = mkAttrsOf' types.str;
  };
}
