{
  inputs,
  lib ? inputs.nixpkgs.lib,
  nix-utils ? inputs.self.lib,
}@args:

let
  inherit (lib)
    fix
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
      nix-utils
    ;
  };
in
fix (self:
  let
    args'' = args' // {
      internal = self;
    };
    importLib = file:
      import file args'';
  in
  mergeListOfAttrs (map importLib libFiles)
)
