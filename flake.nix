{
  description = "small code snippets to reduce code duplication";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        eachDefaultSystem
        eachDefaultSystemMap
      ;

      inherit (nixpkgs.lib)
        recursiveUpdate
      ;
    in
    recursiveUpdate {
      overlays = rec {
        default = nix-utils;

        nix-utils = final: prev: {
          nix-utils = {
            lib = final.callPackage ./lib { };
            pkgs-lib = final.callPackage ./pkgs-lib { };
          };
        };
      };

      lib = import ./lib { inherit (nixpkgs) lib; };
      libs = {
        default = self.lib;
      };
    } (eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        inherit (pkgs) callPackage;
      in
      {
        pkgs-lib = callPackage ./pkgs-lib {
          nix-utils = { inherit (self) lib; };
        };

        libs = recursiveUpdate self.lib self.pkgs-lib.${system};

        packages = rec {
          default = tests.lib;

          tests = {
            lib = callPackage ./tests/lib {
              nix-utils = { inherit (self) lib; };
            };
          };
        };
      }
    ));
}
