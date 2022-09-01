{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    types
  ;

  inherit (nix-alacarte.options)
    default
    mkOption
  ;

  inherit (nix-alacarte.internal.options)
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
