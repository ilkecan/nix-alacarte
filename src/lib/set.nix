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
    headAndTail
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

  partitionAttrs = predicate: set:
    let
      right = filterAttrs predicate set;
    in
    { "0" = right; "1" = removeAttrs set (attrNames right); };

  removeNullAttrs = filterAttrs (_: notNull);

  renameAttrs = f:
    mapAttrs' (name: value: nameValuePair (f name value) value);

  setAttr = name: value: set:
    set // { ${name} = value; };

  setAttrByPath' = attrPath: value: set:
    let
      hat = headAndTail attrPath;
      head = hat."0";
      tail = hat."1";
      value' =
        if tail == [ ]
          then value
          else setAttrByPath' tail value set.${head};
    in
    setAttr head value' set;
}
