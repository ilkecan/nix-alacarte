{ lib, nix-utils }:

let
  inherit (builtins)
    elem
    filter
    listToAttrs
    readDir
  ;

  inherit (lib)
    filterAttrs
    flatten
    hasSuffix
    mapAttrsToList
    nameValuePair
    removeSuffix
  ;

  inherit (lib.asserts)
    assertMsg
  ;

  inherit (nix-utils)
    filesOf
    relTo
  ;
in

{
  filesOf = dir: {
    excludedPaths ? [],
    recursive ? false,
    useRelativePaths ? false,
    withSuffix ? "",
    asAttrs ? false,
  }@args:
    assert assertMsg (asAttrs -> withSuffix != "")
      "`asAttrs` cannot be true while `withSuffix` is an empty string";
    assert assertMsg (asAttrs -> !recursive)
      "`asAttrs` cannot be true while `recursive` is true";

    let
      files = readDir dir;
      f = name: type:
        let
          path = relTo dir name;
          stem = removeSuffix withSuffix name;
          file = if useRelativePaths then name else path;
          file' = if hasSuffix withSuffix name then file else null;
          file'' = if asAttrs then nameValuePair stem file' else file';
        in
        if elem path excludedPaths then null
        else if type == "directory" && recursive then filesOf path args
        else file'';
      files' = mapAttrsToList f files;
      files'' = if recursive then flatten files' else files';
      files''' = if asAttrs then listToAttrs files'' else files'';
      notNull = x: x != null;
      filterFunc = if asAttrs then filterAttrs (_: notNull) else filter notNull;
      files'''' = filterFunc files''';
    in
    files'''';

  relTo = dir: path:
    dir + "/${path}";
}
