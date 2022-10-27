{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fn
    interval
    list
    mkAssertion
    mkThrow
    str
    type
  ;

  inherit (nix-alacarte.internal.exceptionHandling)
    appendScope
    autoColor
    bold
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
      appendScope = fn.compose [ mkAssertion appendScope' ];

      __functor = _:
        assertion;

      attr = attrName: attrs:
        let
          pred = attrs.has attrName attrs;
        in
        pred || throw.missingAttribute attrName attrs;

      type = type': name: value:
        let
          pred = type.of value == type';
        in
        pred || throw.typeMismatch type' name;

      indexBounds = interval': index: list:
        let
          predicate = interval.contains index interval';
        in
        predicate || throw.indexOutOfBounds interval' index list;

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
      scope' = if type.isList scope then str.intercalate "." scope else scope;
      appendScope' = appendScope args;

      prefix = str.optional (scope' != "") "${color'.scope scope'}: ";

      throw = msg:
        builtins.throw "${prefix}${autoColor color' msg}";

      self = {
        appendScope = fn.compose [ mkThrow appendScope' ];

        __functor = _:
          throw;

        indexOutOfBounds =
          let
            prefix = bold "index out of bounds";
          in
          interval':
            let
              interval'' = interval.toString interval';
            in
            index:
              let
                index' = toString index;
              in
              list:
                let
                  list' = toPretty list;
                in
                throw ''${prefix}: index `${index'}` is not within interval ${interval''} for ${list'}'';

        missingAttribute = attrName: attrs:
          throw "attribute `${attrName}` missing in ${toPretty attrs}";

        notOneOf = list: name: value:
          throw "`${name}` is ${toPretty value} but must be one of ${toPretty list}";

        unlessGetAttr = attrName: attrs:
          attrs.${attrName} or (self.missingAttribute attrName attrs);

        typeMismatch = type': name:
          throw "`${name}` is not of type ${type'}";
      };
    in
    self;
}
