{ pkgs, lib, nix-utils }:

let
  inherit (builtins)
    attrNames
    foldl'
    readDir
  ;

  inherit (lib)
    fix
    subtractLists
  ;

  inherit (pkgs)
    callPackage
  ;

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
        nix-utils = nix-utils // self;
      };
  in
  foldl' (l: r: l // r) {} (map importLib libFiles)
)
