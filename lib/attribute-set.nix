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
    headAndTails
    mergeListOfAttrs
    notNull
    optionalValue
    setAttr
    setAttrByPath'
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

  setAttrByPath' = attrPath: value: set:
    let
      inherit (headAndTails attrPath) head tail;
      value' = if tail == [ ] then value else setAttrByPath' tail value set.${head};
    in
    setAttr head value' set;
}
