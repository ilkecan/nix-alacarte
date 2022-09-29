{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    concatStringsSep
    elem
    foldl'
    hasAttr
    isList
  ;

  inherit (lib)
    concatStrings
    id
    mapAttrsToList
    optionalString
    splitString
    toList
  ;

  inherit (lib.generators)
    toPretty
  ;

  inherit (nix-alacarte)
    compose
    even
    imap
    mkAssert
    mkThrow
    pipe'
  ;

  inherit (nix-alacarte.ansi.controlFunctions.controlSequences.SGR)
    blue
    bold
    green
    magenta
    reset
  ;

  boldAnd = color: msg:
    concatStrings [ bold color msg reset ];

  blue' = boldAnd blue;
  magenta' = boldAnd magenta;
  green' = boldAnd green;

  toPretty' = toPretty { };

  appendScope = args:
    newScope:
      args // { scope = toList args.scope or [ ] ++ [ newScope ]; };

  colorMap =
    let
      set = {
        "`" = { name = "codeBlock"; };
        "\"" = { name = "string"; colorDelimiters = true; };
      };
      toSet = delimiter: { name, colorDelimiters ? false }:
        { inherit delimiter name colorDelimiters; };
    in
    mapAttrsToList toSet set;

  autoColor =
    let
      colorOnce = delimiter:
        let
          addDelimiters = str:
            "${delimiter}${str}${delimiter}";
        in
        color: colorDelimiters:
          let
            colorMsg = i:
              if even i then id
              else if colorDelimiters then compose [ color addDelimiters ]
              else compose [ addDelimiters color ];
          in
          pipe' [
            (splitString delimiter)
            (imap colorMsg)
            concatStrings
          ];
    in
    colors:
      let
        colorOnce' = msg: { delimiter, name, colorDelimiters }:
          colorOnce delimiter colors.${name} colorDelimiters msg;
      in
      msg:
        foldl' colorOnce' msg colorMap;
in

{
  mkAssert = args:
    let
      throw' = mkThrow args;
      assert' = pred: msg:
        pred || throw' msg;
    in
    {
      appendScope = compose [ mkAssert (appendScope args) ];

      __functor = _:
        assert';

      attr = attrName: set:
        let
          pred = hasAttr attrName set;
        in
        pred || throw'.missingAttribute attrName set;

      oneOf = list: name: value:
        let
          pred = elem value list;
        in
        pred || throw'.notOneOf list name value;
    };

  mkThrow =
    {
      color ? { },
      scope ? [ ],
      toPretty ? toPretty',
    }@args:
    let
      color' = {
        codeBlock = magenta';
        scope = blue';
        string = green';
      } // color;
      scope' = if isList scope then concatStringsSep "." scope else scope;

      prefix = optionalString (scope' != "") "${color'.scope scope'}: ";

      throw' = msg:
        throw "${prefix}${autoColor color' msg}";
    in
    {
      appendScope = compose [ mkThrow (appendScope args) ];

      __functor = _:
        throw';

      missingAttribute = attrName: set:
        throw' "attribute `${attrName}` missing ${toPretty set}";

      notOneOf = list: name: value:
        throw' "`${name}` is ${toPretty value} but must be one of ${toPretty list}";
    };
}
