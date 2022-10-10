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
    pipe
  ;

  inherit (nix-alacarte)
    attrs
    compose
    str
    enclose
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

    # https://github.com/luvit/luvit/wiki/Lua-Table-Interop-Notation
    toLTIN = { }:
      let
        toString = mkToString {
          bool = boolToString;
          list = value:
            ''
              {
              ${pipe value [
                (list.map (compose [ (enclose "  " ",") toString]))
                unlines
              ]}
              }'';
          null = _:
            "nil";
          set = value:
            ''
              {
              ${pipe value [
                (attrs.mapToList mkKeyValue)
                (list.map (enclose "  " ","))
                unlines
              ]}
              }'';
          string = quote;
        };

        mkKeyValue = key: value:
          let
            value' = pipe value [
              toString
              (indentWith (index: _: str.optional (index != 0) "  "))
            ];
          in
          ''${key} = ${value'}'';
      in
      toString;

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
