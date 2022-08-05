{
  lib,
}@args:

let
  inherit (builtins)
    attrNames
    foldl'
    readDir
  ;

  inherit (lib)
    callPackageWith
    fix
    subtractLists
  ;

  callPackage = callPackageWith args;
  files = attrNames (readDir ./.);
  nonLibFiles = [
    "default.nix"
  ];
  libFiles = subtractLists nonLibFiles files;
in
fix (self:
  let
    importLib = file:
      callPackage "${toString ./.}/${file}" {
        nix-utils = self;
      };
  in
  foldl' (l: r: l // r) {} (map importLib libFiles)
)
