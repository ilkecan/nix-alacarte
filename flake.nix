{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    dnm = {
      url = "github:ilkecan/dnm";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # https://github.com/NixOS/nix/issues/4931
        nix-utils.follows = "";
      };
    };

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
      inherit (inputs.flake-utils.lib)
        eachDefaultSystem
      ;

      inherit (nixpkgs.lib)
        recursiveUpdate
      ;
    in
    recursiveUpdate {
      overlays = {
        default = self.overlays.nix-utils;

        nix-utils = final: _prev: {
          nix-utils =
            final.recursiveUpdate
              (final.callPackage ./src/lib { inherit inputs; })
              (final.callPackage ./src/pkgs-lib { inherit inputs; })
            ;
        };
      };

      bootstrap = import ./src/bootstrap { inherit inputs; };

      lib = import ./src/lib { inherit inputs; };
      libs.default = self.lib;
    } (eachDefaultSystem (system: {
      pkgs-lib = import ./src/pkgs-lib { inherit inputs system; };
      libs = recursiveUpdate self.lib self.pkgs-lib.${system};

      packages = {
        default = self.packages.${system}.tests.lib;
        tests = {
          lib = import ./tests/lib { inherit inputs system; };
        };
      };
    }));
}
