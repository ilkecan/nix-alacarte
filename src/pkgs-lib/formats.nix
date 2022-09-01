{
  alacarte,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    generators
  ;

  inherit (alacarte)
    types
  ;

  inherit (pkgs)
    writeText
  ;

  formats = pkgs.formats // alacarte.formats;
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

    glibKeyFile =
      # https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s03.html
      # https://developer-old.gnome.org/glib/unstable/glib-Key-value-file-parser.html
      # not the same but INI could be used as a starting point
      formats.ini;
  };
}
