{ lib, nix-utils }:

let
  inherit (builtins)
    elem
    filter
    getAttr
    listToAttrs
    pathExists
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
    assertOneOf
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
    return ? "path",
    withExtension ? "",
  }@args:
    assert assertOneOf "return" return [ "path" "name" "stem" ];
    assert assertMsg (return == "stem" -> withExtension != "")
      "`withExtension` cannot be an empty string while `return` is \"stem\"";
    assert assertMsg (recursive -> return == "path")
      "`return` must be \"path\" while `recursive` is true";

    let
      suffix = ".${withExtension}";
      files = readDir dir;
      f = getAttr return;
      f' = if withExtension == "" then const id else
        file: val: if hasSuffix suffix file.name then val else null;
      f'' =
        if asAttrs then
          file: val:
            if val != null then
              nameValuePair file.stem val
            else null
        else
          const id
        ;
      g = name: type:
        let
          path = relTo dir name;
          stem = removeSuffix suffix name;
          file = { inherit name path stem; };

          val = f file;
          val' = f' file val;
          val'' = f'' file val';
        in
        if elem path excludedPaths then null
        else if type == "directory" && recursive then filesOf path args
        else val'';


      files' = mapAttrsToList g files;
      files'' = if recursive then flatten files' else files';
      files''' = filter (x: x != null) files'';
      files'''' = if asAttrs then listToAttrs files''' else files''';
    in
    files'''';

  filterByRelPath = relPath:
    filter (dir: pathExists (relTo dir relPath));

  relTo = dir: path:
    dir + "/${path}";
}
