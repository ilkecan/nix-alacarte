{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    id
  ;

  inherit (nix-alacarte)
    attrs
    compose
    even
    list
    mkAssertion
    mkThrow
    pipe'
    str
  ;

  inherit (nix-alacarte.ansi.controlFunctions.controlSequences.SGR)
    blue
    bold
    green
    magenta
    reset
  ;

  args = { scope = [ "nix-alacarte" ]; };

  boldAnd = color: msg:
    str.concat [ bold color msg reset ];

  colorMap =
    let
      regions = {
        "`" = { name = "codeBlock"; };
        "\"" = { name = "string"; colorDelimiters = true; };
      };
      f = delimiter: { name, colorDelimiters ? false }:
        { inherit delimiter name colorDelimiters; };
    in
    attrs.mapToList f regions;
in

{
  assertion = mkAssertion args;

  exceptionHandling = {
    appendScope = args:
      newScope:
        args // { scope = list.to args.scope or [ ] ++ list.to newScope; };

    autoColor =
      let
        colorOnce = delimiter:
          let
            addDelimiters = str:
              "${delimiter}${str}${delimiter}";
          in
          color: colorDelimiters:
            let
              addColor =
                if colorDelimiters
                  then compose [ color addDelimiters ]
                  else compose [ addDelimiters color ];
              colorMsg = index:
                if even index
                  then id
                  else addColor;
            in
            pipe' [
              (str.split delimiter)
              (list.imap colorMsg)
              str.concat
            ];
      in
      colors:
        let
          colorOnce' = msg: { delimiter, name, colorDelimiters }:
            colorOnce delimiter colors.${name} colorDelimiters msg;
        in
        msg:
          list.foldl' colorOnce' msg colorMap;

    bold = msg:
      str.concat [ bold msg reset ];

    defaultColors = {
      codeBlock = boldAnd magenta;
      scope = boldAnd blue;
      string = boldAnd green;
    };

    toPretty = lib.generators.toPretty { };
  };

  throw = mkThrow args;
}
