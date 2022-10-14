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

  inherit (nix-alacarte)
    attrs
    fn
    list
  ;

  inherit (nix-alacarte.internal)
    throw
  ;

  self = fn;
in

{
  fn =
    let
      throw' = throw.appendScope "fn";
    in
    {
      call = f:
        f;

      callWith = self.flip self.call;

      compose = fs: arg:
        list.foldr self.call arg fs;

      flip = f: x: y:
        f y x;

      id = x:
        x;

      pipe = list.foldl' self.callWith;

      pipe' = self.flip self.pipe;

      ternary = cond: expr1: expr2:
        if cond then expr1 else expr2;

      ternary' = expr1: expr2: cond:
        if cond then expr1 else expr2;

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
}
