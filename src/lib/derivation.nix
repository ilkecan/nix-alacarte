{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    listToAttrs
  ;

  inherit (lib)
    forEach
    getValues
    removeSuffix
  ;

  inherit (nix-utils)
    mergeListOfAttrs
    optionalValue
  ;

  inherit (nix-utils.letterCase)
    kebabToCamel
  ;
in

{
  addPassthru = passthru: drv:
    let
      drv' = mergeListOfAttrs [
        drv
        (listToAttrs outputList)
        passthru
        {
          ${optionalValue (drv ? all) "all"} = getValues outputList;
          passthru = drv.passthru or { } // passthru;
        }
      ];

      outputList = forEach (drv.outputs or [ ]) (outputName: {
        name = outputName;
        value = drv' // {
          inherit (drv.${outputName})
            drvPath
            outPath
            outputName
            passthru
            type
          ;
          outputSpecified = true;
        };
      });
    in drv';

  mkOverlay = args: drvFuncFile:
    (final: prev: {
      ${kebabToCamel (removeSuffix ".nix" (baseNameOf drvFuncFile))} =
          final.callPackage drvFuncFile args;
    });

  sourceOf = pkg:
    pkg.src or pkg;
}