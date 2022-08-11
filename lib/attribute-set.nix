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
    mapAttrs'
    nameValuePair
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

  getExistingAttrs = names: set:
    let
      getAttrIfExists = set: name:
        { ${optionalValue (hasAttr name set) name} = set.${name}; };
    in
    mergeListOfAttrs (map (getAttrIfExists set) names);

  removeNullAttrs = filterAttrs (_: notNull);

  renameAttrs = f:
    mapAttrs' (name: value: nameValuePair (f name value) value);

  setAttr = name: value: set:
    set // { ${name} = value; };
}
