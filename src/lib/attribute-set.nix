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
  ;

  inherit (nix-alacarte)
    attrs
    fn
    fst
    list
    notEqualTo
    notNull
    options
    pair
    snd
  ;

  inherit (nix-alacarte.internal)
    throw
  ;

  inherit (nix-alacarte.internal.attrs)
    mkFold
  ;

  self = attrs;
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
        fn.compose [ (list.count (n: predicate n attrs.${n})) self.names ] attrs;

      filter = lib.filterAttrs;

      foldl = mkFold list.foldl;

      foldl' = mkFold list.foldl';

      foldr = mkFold list.foldr;

      forEach = flip self.map;

      gen = lib.genAttrs;

      get =
        let
          throw'' = throw'.appendScope "get";
        in
        throw''.unlessGetAttr;

      getByPath = self.getByPath' null;

      getByPath' = flip lib.attrByPath;

      getMany =
        let
          nullValue = { __getManyNullValue = null; };
          getAttrOrNullValue = attrs: name:
            attrs.${name} or nullValue;
        in
        names:
          fn.pipe' [
            getAttrOrNullValue
            (self.gen names)
            (self.filter (_: notEqualTo nullValue))
          ];

      has = builtins.hasAttr;

      hasByPath = lib.hasAttrByPath;

      intersect = builtins.intersectAttrs;

      is = builtins.isAttrs;

      map = builtins.mapAttrs;

      map' = f: attrs:
        fn.pipe attrs [
          self.names
          (list.map (attr: f attr attrs.${attr}))
          list.toAttrs
        ];

      mapValues = fn.compose [ self.map const ];

      mapToList = lib.mapAttrsToList;

      merge = lib.mergeAttrs;

      merge' = flip self.merge;

      names = builtins.attrNames;

      optional = lib.optionalAttrs;

      partition = predicate: attrs:
        let
          fst = self.filter predicate attrs;
          snd = self.remove (self.names fst) attrs;
        in
        pair fst snd;

      remove = flip builtins.removeAttrs;

      removeNulls = self.filter (_: notNull);

      rename = f:
        self.map' (name: value: pair (f name value) value);

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

              set = self.set head;
            in
            value: attrs:
              let
                value' =
                  if tail == [ ]
                    then value
                    else self.setByPath tail value attrs.${head};
              in
              set value' attrs;

      setIfMissing = name: value: attrs:
        if self.has name attrs
          then attrs
          else self.set name value attrs;

      size = fn.pipe' [
        self.names
        list.length
      ];

      toList = self.mapToList pair;

      values = builtins.attrValues;

      zip = lib.zipAttrs;

      zipWith = builtins.zipAttrsWith;
    };
}
