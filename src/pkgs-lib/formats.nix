{
  lib,
  nix-alacarte,
  pkgs,
  ...
}:

let
  inherit (lib)
    pipe
  ;

  inherit (nix-alacarte)
    pipe'
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
      pipe args [
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
          pipe' [
            (generators.alacarte.toVDF args)
            (writeText name)
          ];
      };
  };
}
