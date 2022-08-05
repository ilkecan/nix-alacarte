{
  description = "small code snippets to reduce code duplication";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
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
    } // (inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        inherit (pkgs) callPackage;
      in
      {
        pkgs-lib = callPackage ./pkgs-lib {
          nix-utils = { inherit (self) lib; };
        };

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
