{ lib, nix-utils }:

let
  inherit (builtins)
    baseNameOf
  ;

  inherit (lib)
    removeSuffix
  ;

  inherit (nix-utils)
    mergeListOfAttrs
  ;

  inherit (nix-utils.letterCase)
    kebabToCamel
  ;
in

{
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
