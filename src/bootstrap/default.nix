{
  inputs,
  lib ? inputs.nixpkgs.lib,
  bootstrap ? inputs.self.bootstrap,
}:

let
  inherit (builtins)
    attrNames
    foldl'
    readDir
  ;

  inherit (lib)
    recursiveUpdate
    subtractLists
  ;

  inherit (bootstrap)
    mergeListOfAttrs
  ;

  getLibFiles = dir:
    let
      files = attrNames (readDir dir);
      nonLibFiles = [
        "default.nix"
        "internal"
      ];
      libFiles = subtractLists nonLibFiles files;
      dir' = toString dir;
    in
    map (file: "${dir'}/${file}") libFiles;
in

{
  mergeLibFiles = dir: args:
    let
      libFiles = getLibFiles dir;
      importLib = file:
        import file args;
      libs = map importLib libFiles;
    in
    mergeListOfAttrs libs;

  mergeListOfAttrs = foldl' recursiveUpdate { };
}
