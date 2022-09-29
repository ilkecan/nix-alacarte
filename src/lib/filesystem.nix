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
    functionArgs
    getAttr
    intersectAttrs
    isString
    listToAttrs
    mapAttrs
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
    forEachAttr
    nixFiles
    pipe'
    relTo
    removeNulls
    renameAttrs
  ;

  inherit (nix-alacarte.path)
    exists
  ;

  inherit (nix-alacarte.letterCase)
    kebabToCamel
  ;

  inherit (nix-alacarte.internal)
    assertion
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
      assertion' = assertion.appendScope "filesOf";
      self = dir:
        assert assertion'.oneOf [ "path" "name" "stem" ] "return" return;
        assert assertion'  (return == "stem" -> withExtension != "")
          ''`withExtension` cannot be an empty string while `return` is "stem".'';
        assert assertion' (asAttrs -> withExtension != "")
          ''`withExtension` cannot be "" while `asAttrs` is true.'';
        assert assertion' (recursive -> return == "path")
          ''`return` must be "path" while `recursive` is true.'';

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
            in
            pipe file [
              f
              (f' file)
              (f'' file)
              (f''' file)
            ];
        in
        pipe files [
          (mapAttrsToList g)
          (if recursive then flatten else id)
          removeNulls
          (if asAttrs then listToAttrs else id)
        ];
    in
    self;

  filterByRelPath = relPath:
    filter (dir: exists (relTo dir relPath));

  importDirectory =
    {
      convertNameToCamel ? true,
      makeOverridable ? false,
      recursive ? false,
    }:

    let
      nixFiles' = nixFiles {
        inherit
          convertNameToCamel
          recursive
        ;
      };
      f = if makeOverridable then lib.makeOverridable else id;
    in
    dir: args:
      let
        files = nixFiles' dir;
      in
      forEachAttr files (_: path:
        let
          fn = import path;
          fnArgs = intersectAttrs (functionArgs fn) args;
        in
        f fn fnArgs
      );

  relTo = dir: path:
    dir + "/${toString path}";
}
