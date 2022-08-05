{
  lib,
  nix-utils,
  pkgs,
}:

let
  inherit (lib)
    fix
  ;

  inherit (nix-utils.lib)
    filesOf
    mergeListOfAttrs
  ;

  inherit (pkgs)
    callPackage
  ;

  libFiles = filesOf ./. {
    excludedPaths = [ ./default.nix ];
  };
in
fix (self:
  let
    importLib = file:
      callPackage file {
        nix-utils = nix-utils // {
          pkgs-lib = self;
        };
      };
  in
  mergeListOfAttrs (map importLib libFiles)
)
