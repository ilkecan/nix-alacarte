{
  inputs,
  system,
  lib,
  pkgs ? inputs.nixpkgs.legacyPackages.${system},
  ...
}:

let
  inherit (lib)
    generators
    types
  ;

  inherit (pkgs)
    writeText
  ;
in
{
  formats = {
    generic = args: {
      generate = name: value:
        writeText name (generators.toKeyValue args value);
      type =
        let
          genericValue = with types; oneOf [
            bool
            int
            float
            str
            path
            (attrsOf genericValue)
            (listOf genericValue)
          ];
        in
        genericValue;
    };
  };
}
