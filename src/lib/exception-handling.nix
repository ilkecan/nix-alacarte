{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    compose
    list
    mkAssertion
    mkThrow
    str
  ;

  inherit (nix-alacarte.internal.exceptionHandling)
    appendScope
    autoColor
    defaultColors
  ;
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
      toPretty ? nix-alacarte.internal.exceptionHandling.toPretty,
    }@args:
    let
      color' = defaultColors // color;
      scope' = if list.is scope then str.intersperse "." scope else scope;
      appendScope' = appendScope args;

      prefix = str.optional (scope' != "") "${color'.scope scope'}: ";

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
