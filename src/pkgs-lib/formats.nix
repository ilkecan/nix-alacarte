{
  lib,
  nix-alacarte,
  pkgs,
  ...
}:

let
  inherit (nix-alacarte)
    fn
  ;

  inherit (nix-alacarte.internal)
    formats
    generators
    types
  ;

  inherit (pkgs)
    writeText
  ;
in
{
  formats = {
    fromGenerator = generator: {
      generate = name: value:
        writeText name (generator value);
      type = types.alacarte.genericValue;
    };

    generic = args:
      formats.alacarte.fromGenerator (generators.toKeyValue args);

    glibKeyFile = { ... }@args:
      fn.pipe args [
        generators.alacarte.toGlibKeyFile
        formats.alacarte.fromGenerator
      ];

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
        generate = name:
          fn.pipe' [
            (generators.alacarte.toVDF args)
            (writeText name)
          ];
      };

    yaml = { ... }@args:
      let
        valueType = with types; nullOr (oneOf [
          bool
          int
          float
          str
          path
          (attrsOf valueType)
          (listOf valueType)
        ]) // {
          description = "YAML value";
        };
      in
      {
        type = valueType;
        generate = name:
          fn.pipe' [
            (generators.alacarte.toYAML args)
            (writeText name)
          ];
      };
  };
}
