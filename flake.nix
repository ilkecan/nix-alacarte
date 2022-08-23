{
  description = "small code snippets to reduce code duplication";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    overlayln = {
      url = "github:ilkecan/overlayln";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        # https://github.com/NixOS/nix/issues/4931
        nix-utils.follows = "";
      };
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib) eachDefaultSystem;
      inherit (nixpkgs.lib) recursiveUpdate;
    in
    recursiveUpdate {
      overlays = rec {
        default = nix-utils;

        nix-utils = final: _prev: {
          nix-utils =
            final.recursiveUpdate
              (final.callPackage ./lib { inherit inputs; })
              (final.callPackage ./pkgs-lib { inherit inputs; })
            ;
        };
      };

      internal = import ./internal { inherit inputs; };
      static = import ./static { inherit inputs; };
      lib = import ./lib { inherit inputs; };
      libs.default = recursiveUpdate self.static self.lib;
    } (eachDefaultSystem (system: {
      pkgs-lib = import ./pkgs-lib { inherit inputs system; };

      libs = recursiveUpdate self.libs.default self.pkgs-lib.${system};

      packages = rec {
        default = tests;
        tests = import ./tests/lib { inherit inputs system; };
      };
    }));
}
