{
  lib,
  ...
}:

let
  inherit (lib.generators)
    toINI
  ;
in

{
  generators = {
    toGlibKeyFile = { }:
      # https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s03.html
      # https://developer-old.gnome.org/glib/unstable/glib-Key-value-file-parser.html
      # not the same but INI could be used as a starting point
      toINI { };
  };
}
