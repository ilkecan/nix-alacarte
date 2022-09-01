{
  alacarte,
  internal,
  ...
}:

let
  inherit (alacarte)
    types
  ;

  inherit (alacarte.options)
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
