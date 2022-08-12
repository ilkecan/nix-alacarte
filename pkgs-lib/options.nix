{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    types
    options
  ;
in

{
  options = with options; {
    mkSmartPackage = default': fs:
      mkOption (types.smartPackage default') ([ (default { }) ] ++ fs);
    smartPackage = default:
      mkSmartPackage default [ ];
  };
}
