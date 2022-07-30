{
  description = "small code snippets to reduce code duplication";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    nixpkgs.lib.recursiveUpdate {
      overlays = rec {
        default = nix-utils;
        nix-utils = final: prev: {
          nix-utils = final.callPackage ./lib { };
        };
      };

      lib = import ./lib { inherit (nixpkgs) lib; };
    } (inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        inherit (pkgs) callPackage;
      in
      rec {
        lib = callPackage ./lib { };

        packages = rec {
          default = tests;
          tests = callPackage ./tests {
            nix-utils = lib;
          };
        };
      }
    ));
}
