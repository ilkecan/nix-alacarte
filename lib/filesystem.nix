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
    relTo
  ;
in

{
  getFilesWithSuffix = suffix: directory:
    attrValues (getFilesWithSuffix' suffix directory);

  getFilesWithSuffix' = suffix: directory:
    let
      files = filterAttrs
        (file: type: type == "regular" && hasSuffix suffix file)
        (readDir directory);
    in
    mapAttrs (name: _: relTo directory name) files;

  getPatches = getFilesWithSuffix ".patch";

  relTo = dir: path:
    dir + "/${path}";
}
