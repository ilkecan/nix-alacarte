{ lib, nix-utils }:

let
  inherit (builtins)
    attrValues
    filter
    genericClosure
    isAttrs
    map
  ;
  inherit (lib)
    filterAttrs
    flatten
    hasPrefix
    hasSuffix
    unique
  ;
  inherit (nix-utils)
  ;

  wrap = drv: { key = drv.outPath; inherit drv; };
  unwrap = { key, drv }: drv;

  isDependencyKey = key: hasPrefix "deps" key || hasSuffix "Inputs" key;
  getDependencies = drv: attrValues (filterAttrs (key: _: isDependencyKey key) drv.drvAttrs);
  reduceToDerivations = deps: unique (filter isAttrs (flatten deps));
in

rec {
  getClosure = drvs:
    let
      closure = genericClosure {
        startSet = map wrap drvs;
        operator = e: map wrap (reduceToDerivations (getDependencies (unwrap e)));
      };
    in
    map unwrap closure;
}
