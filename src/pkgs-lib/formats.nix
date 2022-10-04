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

  inherit (nix-alacarte.generators)
    toGlibKeyFile
    toVDF
  ;

  inherit (nix-alacarte.formats)
    fromGenerator
  ;

  inherit (nix-alacarte.internal)
    types
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
      type = types.alacarte.genericValue;
    };

    generic = args:
      formats.fromGenerator (generators.toKeyValue args);

    glibKeyFile = { ... }@args:
      fromGenerator (toGlibKeyFile args);

    vdf = { ... }@args:
      let
        valueType = with types; oneOf [
          (attrsOf valueType)
          float
          int
          path
          str
        ] // {
          description = "VDF value";
        };
      in
      {
        type = valueType;
        generate = name: value:
          writeText name (toVDF args value);
      };
  };
}
