{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    typeOf
  ;

  inherit (lib)
    boolToString
  ;

  inherit (nix-alacarte)
    attrs
    compose
    indentBy
    indentWith
    list
    mkToString
    pipe'
    quote
    unlines
  ;

  inherit (nix-alacarte.internal)
    generators
  ;
in

{
  generators = {
    toGlibKeyFile = { }:
      # https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s03.html
      # https://developer-old.gnome.org/glib/unstable/glib-Key-value-file-parser.html
      # not the same but INI could be used as a starting point
      generators.toINI { };

    toKeyValue = { mkKeyValue }:
      pipe' [
        (attrs.mapToList mkKeyValue)
        unlines
      ];

    # https://developer.valvesoftware.com/wiki/KeyValues
    toVDF = { }:
      let
        toString = mkToString { };
        mkKeyValue = key: value:
          if attrs.is value
            then ''
              "${key}"
              {
              ${indentBy 2 (self value)}
              }''
            else ''"${key}" "${toString value}"'';
        self = generators.alacarte.toKeyValue { inherit mkKeyValue; };
      in
      self;

    toYAML = { }:
      let
        toString = mkToString {
          bool = boolToString;
          list = pipe' [
            (list.map (compose [ (indentWith indentListElement) toString ]))
            unlines
          ];
          set = generators.alacarte.toKeyValue { inherit mkKeyValue; };
          string = quote;
        };

        indentListElement = index: _:
          if index == 0 then "- " else "  ";

        mkKeyValue = key: value:
          {
            list = ''
              ${key}:
              ${indentBy 2 (toString value)}'';
            set = ''
              ${key}:
              ${indentBy 2 (toString value)}'';
          }.${typeOf value} or ''${key}: ${toString value}'';
      in
      value:
        ''
          ---
          ${toString value}
        '';
  };
}
