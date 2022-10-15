{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    boolToString
  ;

  inherit (nix-alacarte)
    attrs
    enclose
    fn
    indentBy
    indentWith
    list
    mkToString
    quote
    str
    type
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
      fn.pipe' [
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
              ${fn.pipe value [
                (list.map (fn.compose [ (enclose "  " ",") toString]))
                unlines
              ]}
              }'';
          null = _:
            "nil";
          set = value:
            ''
              {
              ${fn.pipe value [
                (attrs.mapToList mkKeyValue)
                (list.map (enclose "  " ","))
                unlines
              ]}
              }'';
          string = quote;
        };

        mkKeyValue = key: value:
          let
            value' = fn.pipe value [
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
          if type.isAttrs value
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
          list = fn.pipe' [
            (list.map (fn.compose [ (indentWith indentListElement) toString ]))
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
          }.${type.of value} or ''${key}: ${toString value}'';
      in
      value:
        ''
          ---
          ${toString value}
        '';
  };
}
