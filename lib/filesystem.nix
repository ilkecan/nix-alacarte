{ lib, nix-utils }:

let
  inherit (builtins)
    attrNames
    mapAttrs
    readDir
    filter
  ;

  inherit (lib)
    filterAttrs
    hasSuffix
  ;

  inherit (nix-utils)
    getFilesWithSuffix
    listFilenamesWithSuffix
    relTo
  ;
in

{
  getFilesWithSuffix = suffix: dir:
    let
      files = filterAttrs
        (file: _: hasSuffix suffix file)
        (readDir dir);
    in
    mapAttrs (name: _: relTo dir name) files;

  listFilenamesWithSuffix = suffix: dir:
    filter (hasSuffix suffix) (attrNames (readDir dir));

  listFilepathsWithSuffix = suffix: dir:
    let
      filenames = listFilenamesWithSuffix suffix dir;
    in
    map (relTo dir) filenames;

  relTo = dir: path:
    dir + "/${path}";
}
