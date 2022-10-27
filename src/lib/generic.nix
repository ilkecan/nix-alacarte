{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    attrs
    float
    fn
    list
    mkMerge
    mkMergeMany
    type
  ;

  inherit (nix-alacarte.internal)
    assertion
    throw
  ;

  inherit (nix-alacarte.internal.generic)
    withDefaultFns
  ;
in

{
  mkMerge =
    let
      assertion' = assertion.appendScope "mkMerge";
      throw' = throw.appendScope "mkMerge";
    in
    fns:
      let
        fns' = withDefaultFns {
          list = left: right:
            left ++ right;
          null = _: _: builtins.null;
          set = left: right:
            attrs.zipWith (_: mergeMany) [ left right ];
        } fns;
        mergeMany = mkMergeMany fns;
        self = left:
          let
            leftType = type.of left;
            merge = fns'.${leftType} or (throw' "merge function is missing for type ${leftType}");
          in
          right:
            let
              rightType = type.of right;
            in
            assert assertion' (leftType == rightType) "cannot merge ${leftType} with ${rightType}";
            merge left right;
      in
      self;

  mkMergeMany =
    let
      nullValue = { __mkMergeNullValue = null; };
    in
    fns:
      let
        merge = mkMerge fns;
        mergeIfNotNull = left: right:
          if left == nullValue
            then right
            else merge left right;
      in
      values:
        let
          result = list.foldl' mergeIfNotNull nullValue values;
        in
        # TODO: remove null value
        if result == nullValue
          then null
          else result;

  mkToString =
    let
      addFns = withDefaultFns {
        bool = v: if v then "1" else "";
        float = float.toString;
        null = fn.const "";
        string = fn.id;
      };
    in
    fns:
      let
        fns' = addFns fns;
      in
      value:
        let
          toString = fns'.${type.of value} or builtins.toString;
        in
        toString value;
}
