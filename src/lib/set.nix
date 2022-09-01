{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    attrNames
    hasAttr
    mapAttrs
    removeAttrs
  ;

  inherit (lib)
    filterAttrs
    mapAttrs'
    nameValuePair
  ;

  inherit (nix-alacarte)
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

  partitionAttrs = f: set:
    let
      right = filterAttrs f set;
      wrong = removeAttrs set (attrNames right);
    in
    { inherit right wrong; };

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
