{ lib }:

let
  inherit (builtins)
    attrNames
    attrValues
    foldl'
    readDir
  ;
  inherit (lib)
    fix
    genAttrs
    subtractLists
  ;

  files = attrNames (readDir ./.);
  nonLibFiles = [
    "default.nix"
  ];
  libFiles = subtractLists nonLibFiles files;

  nix-utils = fix (self:
    let
      nested = genAttrs libFiles (f:
        import "${toString ./.}/${f}" {
          inherit lib;
          nix-utils = self;
        }
      );
    in
    foldl' (l: r: l // r) {} (attrValues nested)
  );
in
nix-utils
