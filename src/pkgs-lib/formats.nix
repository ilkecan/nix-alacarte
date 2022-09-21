{
  lib,
  nix-alacarte,
  pkgs,
  ...
}:

let
  inherit (lib)
    generators
  ;

  inherit (nix-alacarte)
    types
  ;

  inherit (nix-alacarte.generators)
    toGlibKeyFile
  ;

  inherit (nix-alacarte.formats)
    fromGenerator
  ;

  inherit (pkgs)
    writeText
  ;

  formats = pkgs.formats // nix-alacarte.formats;
in
{
  formats = {
    fromGenerator = generator: {
      generate = name: value:
        writeText name (generator value);
      type = types.genericValue;
    };

    generic = args:
      formats.fromGenerator (generators.toKeyValue args);

    glibKeyFile = { ... }@args:
      fromGenerator (toGlibKeyFile args);
  };
}
