{
  bootstrap,
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    attrs
    equalTo
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
    fromListFn
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

      all = fromListFn list.all;

      any = fromListFn list.any;

      cartesianProduct = lib.cartesianProductOfSets;

      cat = builtins.catAttrs;

      concat = bootstrap.mergeListOfAttrs;

      count = fromListFn list.count;

      empty = equalTo { };

      filter = lib.filterAttrs;

      foldl = mkFold list.foldl;

      foldl' = mkFold list.foldl';

      foldr = mkFold list.foldr;

      forEach = fn.flip self.map;

      gen = lib.genAttrs;

      get =
        let
          throw'' = throw'.appendScope "get";
        in
        throw''.unlessGetAttr;

      getByPath = self.getByPath' null;

      getByPath' = fn.flip lib.attrByPath;

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

      map = builtins.mapAttrs;

      map' = f: attrs:
        fn.pipe attrs [
          self.names
          (list.map (attr: f attr attrs.${attr}))
          list.toAttrs
        ];

      mapValues = fn.compose [ self.map fn.const ];

      mapToList = lib.mapAttrsToList;

      merge = lib.mergeAttrs;

      merge' = fn.flip self.merge;

      names = builtins.attrNames;

      notEmpty = notEqualTo { };

      optional = lib.optionalAttrs;

      partition = predicate: attrs:
        let
          fst = self.filter predicate attrs;
          snd = self.remove (self.names fst) attrs;
        in
        pair fst snd;

      remove = fn.flip builtins.removeAttrs;

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
          then fn.const
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

      size = fn.compose [ list.length self.names ];

      toList = self.mapToList pair;

      values = builtins.attrValues;

      zip = lib.zipAttrs;

      zipWith = builtins.zipAttrsWith;
    };
}
