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
    pipe
    recursiveUpdate
    subtractLists
  ;

  inherit (bootstrap)
    mergeListOfAttrs
  ;

  getFiles = dir: { exclude ? [ ] }:
    let
      dir' = toString dir;
      mkFilepath = filename:
        "${dir'}/${filename}";
    in
    pipe dir [
      readDir
      attrNames
      (subtractLists exclude)
      (map mkFilepath)
    ];
in

{
  mergeLibFiles = dir: args:
    {
      exclude ? [
        "default.nix"
        "internal"
      ]
    }:
    let
      importLib = file:
        import file args;
      files = getFiles dir { inherit exclude; };
    in
    pipe files [
      (map importLib)
      mergeListOfAttrs
    ];

  mergeListOfAttrs = foldl' recursiveUpdate { };
}
