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
    smartPackage = default':
      withDefault [ (default { }) ]
        (mkOption (types.smartPackage default'));
  };
in

{
  options = generateOptions optionFunctions;
}
