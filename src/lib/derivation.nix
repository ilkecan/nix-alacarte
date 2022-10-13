{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    getValues
    removeSuffix
  ;

  inherit (nix-alacarte)
    attrs
    list
    optionalValue
    pair
  ;

  inherit (nix-alacarte.letterCase)
    kebabToCamel
  ;
in

{
  addPassthru = passthru: drv:
    let
      drv' = attrs.concat [
        drv
        (list.toAttrs outputList)
        passthru
        {
          ${optionalValue (drv ? all) "all"} = getValues outputList;
          passthru = drv.passthru or { } // passthru;
        }
      ];

      outputList = list.forEach (drv.outputs or [ ]) (name:
        let
          value = drv' // {
            inherit (drv.${name})
              drvPath
              outPath
              outputName
              passthru
              type
            ;
            outputSpecified = true;
          };
        in
        pair name value
      );
    in drv';

  drv = {
    source = drv:
      drv.src or drv;
  };

  mkOverlay = args: drvFuncFile:
    (final: _prev: {
      ${kebabToCamel (removeSuffix ".nix" (baseNameOf drvFuncFile))} =
          final.callPackage drvFuncFile args;
    });
}
