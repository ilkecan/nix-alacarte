{
  description = "small code snippets to reduce code duplication";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
  };

  outputs = { self, nixpkgs }: {
    lib = import ./lib { inherit (nixpkgs) lib; };
  };
}
