{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    id
  ;

  inherit (lib.generators)
    toPretty
  ;

  inherit (nix-alacarte)
    attrs
    compose
    even
    list
    mkAssertion
    mkThrow
    pipe'
    string
  ;

  inherit (nix-alacarte.ansi.controlFunctions.controlSequences.SGR)
    blue
    bold
    green
    magenta
    reset
  ;

  boldAnd = color: msg:
    string.concat [ bold color msg reset ];

  blue' = boldAnd blue;
  magenta' = boldAnd magenta;
  green' = boldAnd green;

  toPretty' = toPretty { };

  appendScope = args:
    newScope:
      args // { scope = list.to args.scope or [ ] ++ list.to newScope; };

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
            (string.split delimiter)
            (list.imap colorMsg)
            string.concat
          ];
    in
    colors:
      let
        colorOnce' = msg: { delimiter, name, colorDelimiters }:
          colorOnce delimiter colors.${name} colorDelimiters msg;
      in
      msg:
        list.foldl' colorOnce' msg colorMap;
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

      attr = attrName: attrs:
        let
          pred = attrs.has attrName attrs;
        in
        pred || throw.missingAttribute attrName attrs;

      oneOf = list': name: value:
        let
          pred = list.elem value list';
        in
        pred || throw.notOneOf list' name value;
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
      scope' = if list.is scope then string.intersperse "." scope else scope;
      appendScope' = appendScope args;

      prefix = string.optional (scope' != "") "${color'.scope scope'}: ";

      throw = msg:
        builtins.throw "${prefix}${autoColor color' msg}";

      self = {
        appendScope = compose [ mkThrow appendScope' ];

        __functor = _:
          throw;

        missingAttribute = attrName: attrs:
          throw "attribute `${attrName}` missing in ${toPretty attrs}";

        notOneOf = list: name: value:
          throw "`${name}` is ${toPretty value} but must be one of ${toPretty list}";

        unlessGetAttr = attrName: attrs:
          attrs.${attrName} or (self.missingAttribute attrName attrs);
      };
    in
    self;
}
