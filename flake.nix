{
  description = "small code snippets to reduce code duplication";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
  };

  outputs = { self, nixpkgs }: {
    overlay = final: prev: {
      nix-utils = import ./lib { inherit (final) lib; };
    };

    lib = import ./lib { inherit (nixpkgs) lib; };

    tests = import ./tests {
      inherit (nixpkgs) lib;
      nix-utils = self.lib;
    };
  };
}
