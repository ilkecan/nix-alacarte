{
  lib,
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    types
  ;

  inherit (nix-utils.options)
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
