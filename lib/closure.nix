{ lib, nix-utils }:

let
  inherit (builtins)
    attrValues
    filter
    genericClosure
    isAttrs
  ;

  inherit (lib)
    filterAttrs
    flatten
    hasPrefix
    hasSuffix
    unique
  ;

  wrap = drv: { key = drv.outPath; inherit drv; };
  unwrap = { key, drv }: drv;

  isDependencyKey = key: hasPrefix "deps" key || hasSuffix "Inputs" key;
  getDependencies = drv: attrValues (filterAttrs (key: _: isDependencyKey key) drv.drvAttrs);
  reduceToDerivations = deps: unique (filter isAttrs (flatten deps));
in

{
  closureOf = drvs:
    let
      closure = genericClosure {
        startSet = map wrap drvs;
        operator = e: map wrap (reduceToDerivations (getDependencies (unwrap e)));
      };
    in
    map unwrap closure;
}
