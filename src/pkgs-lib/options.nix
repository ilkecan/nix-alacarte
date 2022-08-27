{
  nix-utils,
  internal,
  ...
}:

let
  inherit (nix-utils)
    types
  ;

  inherit (nix-utils.options)
    default
    mkOption
  ;

  inherit (internal.options)
    generateOptions
    withDefault
  ;

  optionFunctions = {
    smartPackage =
      withDefault [ (default { }) ]
        mkOption types.smartPackage;
  };
in

{
  options = generateOptions optionFunctions;
}
