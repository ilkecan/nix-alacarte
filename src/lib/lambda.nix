{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    functionArgs
    typeOf
  ;

  inherit (lib)
    flip
    foldr
    pipe
  ;

  inherit (nix-alacarte)
    attrs
    call
  ;

  inherit (nix-alacarte.internal)
    throw
  ;
in

{
  call = f:
    f;

  callWith = flip call;

  compose = fs: arg:
    foldr call arg fs;

  fn =
    let
      throw' = throw.appendScope "fn";
    in
    {
      toAttrs =
        let
          throw'' = throw'.appendScope "toAttrs";
        in
        function:
          let
            type = typeOf function;
          in
          {
            lambda = {
              __functor = _: function;
              __functionArgs = functionArgs function;
            };

            set =
              let
                function' = function.__functor or (
                  throw'' "not a function, `__functor` attribute is missing"
                );
              in
              attrs.setIfMissing "__functionArgs" (functionArgs function') function;
          }.${type} or (throw'' "not a function but `${type}`");
    };

  pipe' = flip pipe;

  ternary = cond: expr1: expr2:
    if cond then expr1 else expr2;

  ternary' = expr1: expr2: cond:
    if cond then expr1 else expr2;
}
