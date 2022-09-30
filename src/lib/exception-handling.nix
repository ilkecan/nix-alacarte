{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    elem
    foldl'
    hasAttr
    isList
  ;

  inherit (lib)
    id
    mapAttrsToList
    toList
  ;

  inherit (lib.generators)
    toPretty
  ;

  inherit (nix-alacarte)
    compose
    even
    imap
    mkAssertion
    mkThrow
    pipe'
  ;

  inherit (nix-alacarte.string)
    concat
    intersperse
    optional
    split
  ;

  inherit (nix-alacarte.ansi.controlFunctions.controlSequences.SGR)
    blue
    bold
    green
    magenta
    reset
  ;

  boldAnd = color: msg:
    concat [ bold color msg reset ];

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
            (split delimiter)
            (imap colorMsg)
            concat
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
  mkAssertion = args:
    let
      appendScope' = appendScope args;
      throw = mkThrow args;
      assertion = pred: msg:
        pred || throw msg;
    in
    {
      appendScope = compose [ mkAssertion appendScope' ];

      __functor = _:
        assertion;

      attr = attrName: set:
        let
          pred = hasAttr attrName set;
        in
        pred || throw.missingAttribute attrName set;

      oneOf = list: name: value:
        let
          pred = elem value list;
        in
        pred || throw.notOneOf list name value;
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
      scope' = if isList scope then intersperse "." scope else scope;
      appendScope' = appendScope args;

      prefix = optional (scope' != "") "${color'.scope scope'}: ";

      throw = msg:
        builtins.throw "${prefix}${autoColor color' msg}";

      self = {
        appendScope = compose [ mkThrow appendScope' ];

        __functor = _:
          throw;

        missingAttribute = attrName: set:
          throw "attribute `${attrName}` missing in ${toPretty set}";

        notOneOf = list: name: value:
          throw "`${name}` is ${toPretty value} but must be one of ${toPretty list}";

        unlessGetAttr = attrName: set:
          set.${attrName} or (self.missingAttribute attrName set);
      };
    in
    self;
}
