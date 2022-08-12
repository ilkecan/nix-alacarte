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
    formats
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

    glibKeyFile =
      # https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s03.html
      # https://developer-old.gnome.org/glib/unstable/glib-Key-value-file-parser.html
      # not the same but INI could be used as a starting point
      formats.ini;
  };
}
