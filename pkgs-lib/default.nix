{
  inputs,
  system,
  lib ? inputs.nixpkgs.lib,
  nix-utils ? inputs.self.lib,
}@args:

let
  inherit (lib)
    fix
    recursiveUpdate
  ;

  inherit (nix-utils)
    filesOf
    mergeListOfAttrs
  ;

  libFiles = filesOf ./. {
    excludedPaths = [ ./default.nix ];
  };

  args' = args // {
    inherit
      lib
    ;
  };
in
fix (self:
  let
    args'' = args' // {
      nix-utils = recursiveUpdate nix-utils self;
    };
    importLib = file:
      import file args'';
  in
  mergeListOfAttrs (map importLib libFiles)
)
