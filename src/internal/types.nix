{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    options
  ;

  inherit (nix-alacarte.internal)
    types
  ;

  inherit (nix-alacarte.internal.types')
    toPackageSubmoduleConfig
  ;

  mkArgType = name:
    types.submodule {
      options = with options; {
        env = str;
        sep = str;
        ${name} = str;
      };
    };
in

{
  types = lib.types // { alacarte = nix-alacarte.types; };

  types' = {
    prefixArg = mkArgType "val";
    prefixContentsArg = mkArgType "files";
    prefixEachArg = mkArgType "vals";

    toPackageSubmoduleConfig = package:
      if types.package.check package then
        { drv = package; }
      else
        package
      ;

    toPackageSubmoduleDef = { file, value }:
      { inherit file; value = toPackageSubmoduleConfig value; };
  };
}
