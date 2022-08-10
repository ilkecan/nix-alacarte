{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    hasAttr
    mapAttrs
  ;

  inherit (lib)
    filterAttrs
  ;

  inherit (nix-utils)
    mergeListOfAttrs
    notNull
    optionalValue
  ;
in

{
  forEachAttr = set: f:
    mapAttrs f set;

  getExistingAttrs = names: attrs:
    let
      getAttrIfExists = attrs: name:
        { ${optionalValue (hasAttr name attrs) name} = attrs.${name}; };
    in
    mergeListOfAttrs (map (getAttrIfExists attrs) names);

  removeNullAttrs = filterAttrs (_: notNull);
}
