{ lib, nix-utils }:

let
  inherit (builtins)
    elem
    filter
    getAttr
    listToAttrs
    readDir
  ;

  inherit (lib)
    const
    flatten
    hasSuffix
    id
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
    asAttrs ? false,
    excludedPaths ? [],
    recursive ? false,
    stripSuffix ? asAttrs,
    useRelativePaths ? false,
    withSuffix ? "",
  }@args:
    assert assertMsg (stripSuffix -> withSuffix != "")
      "`stripSuffix` cannot be true while `withSuffix` is an empty string";
    assert assertMsg (stripSuffix -> !recursive)
      "`stripSuffix` cannot be true while `recursive` is true";
    assert assertMsg (asAttrs -> stripSuffix)
      "`asAttrs` cannot be true while `stripSuffix` is false";

    let
      files = readDir dir;
      g = if useRelativePaths then getAttr "name" else getAttr "path";
      g' =
        if withSuffix == "" then const id
        else file: val: if hasSuffix withSuffix file.name then val else null;
      g'' =
        if asAttrs then
          file: val: if val != null then nameValuePair file.stem val else null
        else
          _: val: if stripSuffix && withSuffix != "" then removeSuffix withSuffix val else val
        ;
      f = name: type:
        let
          path = relTo dir name;
          stem = removeSuffix withSuffix name;
          file = { inherit name path stem; };

          val = g file;
          val' = g' file val;
          val'' = g'' file val';
        in
        if elem path excludedPaths then null
        else if type == "directory" && recursive then filesOf path args
        else val'';


      files' = mapAttrsToList f files;
      files'' = if recursive then flatten files' else files';
      files''' = filter (x: x != null) files'';
      files'''' = if asAttrs then listToAttrs files''' else files''';
    in
    files'''';

  relTo = dir: path:
    dir + "/${path}";
}
