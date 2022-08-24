{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    hasAttr
    head
    typeOf
  ;

  inherit (lib)
    getValues
    mergeEqualOption
    mkOptionType
  ;

  inherit (lib.strings)
    isCoercibleToString
  ;

  inherit (nix-utils)
    allEqual
    fmtValue
  ;

  types = lib.types // nix-utils.types;
in

{
  types = {
    coercibleToString = coerceFunctions:
      let
        self = mkOptionType {
          name = "coercibleToString";
          check = x:
            hasAttr (typeOf x) coerceFunctions || isCoercibleToString x;
          merge = loc: defs:
            let
              values = getValues defs;
              valueTypes = map typeOf values;
              toStr = fmtValue coerceFunctions;
            in
            if allEqual valueTypes then
              {
                list = (types.listOf self).merge;
                set = (types.attrsOf self).merge;  # maybe this should also be mergeEqualOption?
              }.${head valueTypes} or mergeEqualOption loc defs
            else
              types.string.merge
                loc
                (map (def: def // { value = toStr def.value; }) defs)
            ;
        };
      in
      self;

    genericValue =
      let
        type = with types; oneOf [
          bool
          int
          float
          str
          path
          (attrsOf type)
          (listOf type)
        ] // {
          description = "genericValue";
        };
      in
      type;
  };
}
