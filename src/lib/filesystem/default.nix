{
  bootstrap,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    functionArgs
    readDir
  ;

  inherit (lib)
    hasSuffix
    mapNullable
    removeSuffix
  ;

  inherit (bootstrap)
    mergeLibFiles
  ;

  inherit (nix-alacarte)
    attrs
    dirToAttrs
    filesOf
    fn
    list
    nixFiles
    pair
    path
    type
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
      mkAbsolute = path.relativeTo dir;
    in
    fn.pipe dir [
      readDir
      (attrs.map (name: type:
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

    fn.pipe' [
      (filesOf {
        inherit
          excludedPaths
          recursive
        ;
        withExtension = "nix";
        asAttrs = true;
      })
      (if convertNameToCamel
        then attrs.rename (name: _: kebabToCamel name)
        else fn.id)
    ];

  filesOf =
    let
      assertion' = assertion.appendScope "filesOf";
    in
    {
      asAttrs ? false,
      excludedPaths ? [ ],
      recursive ? false,
      return ? "path",
      withExtension ? "",
    }:
    let
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
          mkAbsolute = path':
            if type.isStr path' then path.relativeTo dir path' else path';
          excludedPaths' = list.map mkAbsolute excludedPaths;
          f = attrs.get return;
          f' = if withExtension == "" then fn.const fn.id else
            file: val: if hasSuffix suffix file.name then val else null;
          f'' = file: val:
            if list.elem file.path excludedPaths' then null
            else if file.type == "directory" && recursive then self file.path
            else val;
          f''' =
            if asAttrs then
              file:
                mapNullable (pair file.stem)
            else
              fn.const fn.id
            ;
          g = name: type:
            let
              path' = path.relativeTo dir name;
              stem = removeSuffix suffix name;
              file = { inherit name stem type; path = path'; };
            in
            fn.pipe file [
              f
              (f' file)
              (f'' file)
              (f''' file)
            ];
        in
        fn.pipe files [
          (attrs.mapToList g)
          (if recursive then list.flatten else fn.id)
          (list.remove null)
          (if asAttrs then list.toAttrs else fn.id)
        ];
    in
    self;

  filterByRelPath = relPath:
    list.filter (dir: path.exists (path.relativeTo dir relPath));

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
      f = if makeOverridable then lib.makeOverridable else fn.id;
    in
    dir: args:
      let
        files = nixFiles' dir;
      in
      attrs.forEach files (_: path:
        let
          fn = import path;
          fnArgs = attrs.intersect (functionArgs fn) args;
        in
        f fn fnArgs
      );
}
