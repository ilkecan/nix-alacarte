{
  bootstrap,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elem
    filter
    getAttr
    isString
    listToAttrs
    mapAttrs
    pathExists
    readDir
  ;

  inherit (lib)
    const
    flatten
    hasSuffix
    id
    mapAttrsToList
    mapNullable
    nameValuePair
    pipe
    removeSuffix
  ;

  inherit (bootstrap)
    mergeLibFiles
  ;

  inherit (nix-alacarte)
    dirToAttrs
    filesOf
    nixFiles
    pipe'
    relTo
    removeNulls
    renameAttrs
  ;

  inherit (nix-alacarte.letterCase)
    kebabToCamel
  ;

  inherit (nix-alacarte.internal)
    assertMsg'
    assertOneOf'
    colorVariable
  ;
in

{
  dirToAttrs = dir:
    let
      mkAbsolute = relTo dir;
    in
    pipe dir [
      readDir
      (mapAttrs (name: type:
        let
          path = mkAbsolute name;
        in
        if type == "directory"
          then dirToAttrs path
          else path
      ))
    ];

  inherit mergeLibFiles;

  nixFiles =
    {
      convertNameToCamel ? true,
      excludedPaths ? [ "default.nix" ],
      recursive ? false,
    }:

    pipe' [
      (filesOf {
        inherit
          excludedPaths
          recursive
        ;
        withExtension = "nix";
        asAttrs = true;
      })
      (if convertNameToCamel
        then renameAttrs (name: _: kebabToCamel name)
        else id)
    ];

  filesOf =
    {
      asAttrs ? false,
      excludedPaths ? [ ],
      recursive ? false,
      return ? "path",
      withExtension ? "",
    }:

    let
      self = dir:
        let
          assertMsg'' = assertMsg' "filesOf";
        in
        assert assertOneOf' "filesOf" "return" return [ "path" "name" "stem" ];
        assert assertMsg''  (return == "stem" -> withExtension != "")
          "`${colorVariable "withExtension"}` cannot be an empty string while `${colorVariable "return"}` is \"stem\".";
        assert assertMsg'' (asAttrs -> withExtension != "")
          "`${colorVariable "withExtension"}` cannot be an empty string while `${colorVariable "asAttrs"}` is true.";
        assert assertMsg'' (recursive -> return == "path")
          "`${colorVariable "return"}` must be \"path\" while `${colorVariable "recursive"}` is true.";

        let
          suffix = ".${withExtension}";
          files = readDir dir;
          mkAbsolute = path:
            if isString path then relTo dir path else path;
          excludedPaths' = map mkAbsolute excludedPaths;
          f = getAttr return;
          f' = if withExtension == "" then const id else
            file: val: if hasSuffix suffix file.name then val else null;
          f'' = file: val:
            if elem file.path excludedPaths' then null
            else if file.type == "directory" && recursive then self file.path
            else val;
          f''' =
            if asAttrs then
              file:
                mapNullable (nameValuePair file.stem)
            else
              const id
            ;
          g = name: type:
            let
              path = relTo dir name;
              stem = removeSuffix suffix name;
              file = { inherit name path stem type; };

              val = f file;
              val' = f' file val;
              val'' = f'' file val';
              val''' = f''' file val'';
            in
            val''';

          files' = mapAttrsToList g files;
          files'' = if recursive then flatten files' else files';
          files''' = removeNulls files'';
          files'''' = if asAttrs then listToAttrs files''' else files''';
        in
        files'''';
    in
    self;

  filterByRelPath = relPath:
    filter (dir: pathExists (relTo dir relPath));

  importDirectory =
    {
      recursive ? false,
    }:

    dir: args:
      let
        files = nixFiles { inherit recursive; } dir;
      in
      mapAttrs (_: path: import path args) files;

  relTo = dir: path:
    dir + "/${toString path}";
}
