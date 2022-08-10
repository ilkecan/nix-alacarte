{
  inputs,
  lib ? inputs.nixpkgs.lib,
}@args:

let
  inherit (builtins)
    attrNames
    foldl'
    readDir
  ;

  inherit (lib)
    fix
    subtractLists
  ;

  # https://github.com/NixOS/nix/issues/1461
  args' = args // { inherit lib; };
  files = attrNames (readDir ./.);
  nonLibFiles = [
    "default.nix"
  ];
  libFiles = subtractLists nonLibFiles files;
in
fix (self:
  let
    args'' = args' // {
      nix-utils = self;
    };
    importLib = file:
    import "${toString ./.}/${file}" args'';
  in
  foldl' (l: r: l // r) {} (map importLib libFiles)
)
