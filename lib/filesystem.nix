{ lib, nix-utils }:

let
  inherit (builtins)
    attrNames
    filter
    listToAttrs
    readDir
  ;

  inherit (lib)
    hasSuffix
    nameValuePair
    removeSuffix
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
      filenames = listFilenamesWithSuffix suffix dir;
      filenamePathPair = f:
        nameValuePair (removeSuffix suffix f) (relTo dir f);
    in
    listToAttrs (map filenamePathPair filenames);

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
