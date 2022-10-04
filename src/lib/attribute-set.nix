{
  bootstrap,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    const
    flip
    pipe
  ;

  inherit (nix-alacarte)
    attrs
    compose
    fst
    list
    notEqualTo
    notNull
    options
    pair
    pipe'
    snd
  ;

  inherit (attrs)
    concat
    filter
    gen
    getByPath'
    has
    map
    map'
    mapToList
    merge
    names
    remove
    set
    setByPath
    zipWith
  ;

  inherit (nix-alacarte.internal)
    throw
  ;

  inherit (nix-alacarte.internal.attrs)
    mkFold
  ;
in

{
  attrs =
    let
      throw' = throw.appendScope "attrs";
    in
    {
      __functor = _:
        options.attrs;

      cartesianProduct = lib.cartesianProductOfSets;

      cat = builtins.catAttrs;

      concat = bootstrap.mergeListOfAttrs;

      count = predicate: attrs:
        compose [ (list.count (n: predicate n attrs.${n})) names ] attrs;

      filter = lib.filterAttrs;

      foldl = mkFold list.foldl;

      foldl' = mkFold list.foldl';

      foldr = mkFold list.foldr;

      forEach = flip map;

      gen = lib.genAttrs;

      get =
        let
          throw'' = throw'.appendScope "get";
        in
        throw''.unlessGetAttr;

      getByPath = getByPath' null;

      getByPath' = flip lib.attrByPath;

      getMany =
        let
          nullValue = { __getManyNullValue = null; };
          getAttrOrNullValue = attrs: name:
            attrs.${name} or nullValue;
        in
        names:
          pipe' [
            getAttrOrNullValue
            (gen names)
            (filter (_: notEqualTo nullValue))
          ];

      has = builtins.hasAttr;

      hasByPath = lib.hasAttrByPath;

      intersect = builtins.intersectAttrs;

      is = builtins.isAttrs;

      map = builtins.mapAttrs;

      map' = f: attrs:
        pipe attrs [
          names
          (list.map (attr: f attr attrs.${attr}))
          list.toAttrs
        ];

      mapValues = compose [ map const ];

      mapToList = lib.mapAttrsToList;

      merge = lib.mergeAttrs;

      merge' = flip merge;

      names = builtins.attrNames;

      optional = lib.optionalAttrs;

      partition = predicate: attrs:
        let
          right = filter predicate attrs;
        in
        pair right (remove (names right) attrs);

      remove = flip builtins.removeAttrs;

      removeNulls = filter (_: notNull);

      rename = f:
        map' (name: value: pair (f name value) value);

      set = name: value: attrs:
        attrs // { ${name} = value; };

      setByPath = attrPath:
        let
          result = list.uncons attrPath;
        in
        if result == null
          then const
          else
            let
              head = fst result;
              tail = snd result;

              set' = set head;
            in
            value: attrs:
              let
                value' =
                  if tail == [ ]
                    then value
                    else setByPath tail value attrs.${head};
              in
              set' value' attrs;

      toList = mapToList pair;

      values = builtins.attrValues;

      zip = lib.zipAttrs;

      zipWith = builtins.zipAttrsWith;
    };
}
