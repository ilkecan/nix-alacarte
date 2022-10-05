{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    genericClosure
  ;

  inherit (lib)
    hasPrefix
    hasSuffix
    unique
  ;

  inherit (nix-alacarte)
    attrs
    combinators
    list
  ;

  wrap = drv: { key = drv.outPath; inherit drv; };
  unwrap = { key, drv }: drv;

  isDependencyKey = combinators.or [ (hasPrefix "deps") (hasSuffix "Inputs") ];
  getDependencies = drv: attrs.values (attrs.filter (key: _: isDependencyKey key) drv.drvAttrs);
  reduceToDerivations = deps: unique (list.filter attrs.is (list.flatten deps));
in

{
  closureOf = drvs:
    let
      closure = genericClosure {
        startSet = list.map wrap drvs;
        operator = e: list.map wrap (reduceToDerivations (getDependencies (unwrap e)));
      };
    in
    list.map unwrap closure;
}
