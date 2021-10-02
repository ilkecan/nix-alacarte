{ lib, nix-utils }:

let
  inherit (builtins)
    attrNames
    readDir
  ;
  inherit (lib)
    filterAttrs
    hasSuffix
  ;
  inherit (nix-utils)
  ;
in

rec {
  getFilesWithSuffix = suffix: directory:
    let
      files = filterAttrs
        (file: type: type == "regular" && hasSuffix suffix file)
        (readDir directory);
    in
    map (f: directory + "/${f}") (attrNames files);

  getPatches = directory:
    getFilesWithSuffix ".patch" directory;
}
