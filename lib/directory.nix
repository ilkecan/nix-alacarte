{ lib, nix-utils }:

let
  inherit (builtins)
    attrValues
    mapAttrs
    readDir
  ;

  inherit (lib)
    filterAttrs
    hasSuffix
  ;

  inherit (nix-utils)
    getFilesWithSuffix
    getFilesWithSuffix'
  ;
in

{
  getFilesWithSuffix' = suffix: directory:
    let
      files = filterAttrs
        (file: type: type == "regular" && hasSuffix suffix file)
        (readDir directory);
    in
    mapAttrs (name: _: directory + "/${name}") files;

  getFilesWithSuffix = suffix: directory:
    attrValues (getFilesWithSuffix' suffix directory);

  getPatches = getFilesWithSuffix ".patch";
}
