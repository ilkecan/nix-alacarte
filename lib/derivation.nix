{ lib, nix-utils }:

let
  inherit (builtins)
    baseNameOf
    listToAttrs
  ;

  inherit (lib)
    removeSuffix
    forEach
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
      drv' = drv // listToAttrs outputList // passthru // {
        ${optionalValue (drv ? all) "all"} = all;
        passthru = drv.passthru or { } // passthru;
      };

      all = map (x: x.value) outputList;
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

  mkOverlay = inputs: drvFuncFile:
    (final: prev: {
      ${kebabToCamel (removeSuffix ".nix" (baseNameOf drvFuncFile))} =
          final.callPackage drvFuncFile { inherit inputs; };
    });

  overridePackageWith = pkg: overrides:
    pkg.override (mergeListOfAttrs overrides);

  sourceOf = pkg:
    pkg.src or pkg;
}
