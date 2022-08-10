{
  lib,
  nix-utils,
  ...
}:

let
  inherit (nix-utils.pkgs-lib)
    types
  ;

  inherit (nix-utils.lib.options)
    mkOption
  ;
in

{
  options = {
    smartPackage = mkOption (types.smartPackage { });
    mkSmartPackage = default:
      mkOption (types.smartPackage default);
  };
}
