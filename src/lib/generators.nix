{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    isAttrs
  ;

  inherit (lib.generators)
    toINI
    toKeyValue
  ;

  inherit (nix-alacarte)
    fmtValue
    indentBy
  ;
in

{
  generators = {
    toGlibKeyFile = { }:
      # https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s03.html
      # https://developer-old.gnome.org/glib/unstable/glib-Key-value-file-parser.html
      # not the same but INI could be used as a starting point
      toINI { };

    # https://developer.valvesoftware.com/wiki/KeyValues
    toVDF = { }:
      let
        fmtValue' = fmtValue { };
        mkKeyValue = key: value:
          if isAttrs value
            then ''
              "${key}"
              {
              ${indentBy 2 (self value)}
              }''
            else ''"${key}" "${fmtValue' value}"'';
        self = toKeyValue { inherit mkKeyValue; };
      in
      self;
  };
}
