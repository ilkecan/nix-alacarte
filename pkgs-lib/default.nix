{
  inputs,
  system,
  lib ? inputs.nixpkgs.lib,
  nix-utils ? { inherit (inputs.self) lib; },
}@args:

let
  inherit (lib)
    fix
  ;

  inherit (nix-utils.lib)
    filesOf
    mergeListOfAttrs
  ;

  libFiles = filesOf ./. {
    excludedPaths = [ ./default.nix ];
  };

  args' = args // {
    inherit
      lib
      nix-utils
    ;
  };
in
fix (self:
  let
    args'' = args' // {
      nix-utils = nix-utils // {
        pkgs-lib = self;
      };
    };
    importLib = file:
      import file args'';
  in
  mergeListOfAttrs (map importLib libFiles)
)
