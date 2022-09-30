{
  bootstrap,
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
    fst
    uncons
    mergeListOfAttrs
    notNull
    optionalValue
    pair
    setAttr
    setAttrByPath'
    snd
  ;

  inherit (nix-alacarte.internal)
    assertion
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

  partitionAttrs = predicate: set:
    let
      right = filterAttrs predicate set;
    in
    pair right (removeAttrs set (attrNames right));

  removeNullAttrs = filterAttrs (_: notNull);

  renameAttrs = f:
    mapAttrs' (name: value: nameValuePair (f name value) value);

  setAttr = name: value: set:
    set // { ${name} = value; };

  setAttrByPath' =
    let
      assertion' = assertion.appendScope "setAttrByPath'";
    in
    attrPath:
    let
      result = uncons attrPath;
      head = fst result;
      tail = snd result;
    in
    assert assertion' (result != null) "empty attribute path";
    value: set:
    let
      value' =
        if tail == [ ]
          then value
          else setAttrByPath' tail value set.${head};
    in
    setAttr head value' set;

  inherit (bootstrap)
    mergeListOfAttrs
  ;
}
