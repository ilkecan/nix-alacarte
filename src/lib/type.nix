{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    type
  ;

  self = type;
in
{
  type = {
    isAttrs = builtins.isAttrs;
    isBool = builtins.isBool;
    isFloat = builtins.isFloat;

    isFn = x:
      self.isLambda x || (x ? __functor && self.isFn (x.__functor  x));

    isInt = builtins.isInt;
    isLambda = builtins.isFunction;
    isList = builtins.isList;
    isNull = builtins.isNull;
    isPath = builtins.isPath;
    isStr = builtins.isString;

    of = builtins.typeOf;
  };
}
