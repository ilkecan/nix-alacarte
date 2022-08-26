{
  nix-utils,
  internal,
  ...
}:

let
  inherit (builtins)
    isFunction
    mapAttrs
  ;

  inherit (nix-utils)
    capitalize
    mergeListOfAttrs
    renameAttrs
  ;

  inherit (internal.options)
    withDefault
  ;

  toOption = mkOptionFunction:
    let
      maybeOption = mkOptionFunction [ ];
    in
    if isFunction maybeOption then
      arg:
        toOption (mkOptionFunction arg)
    else
      maybeOption
    ;
in

{
  options = {
    generateOptions = optionFunctions:
      mergeListOfAttrs [
        (mapAttrs (_name: toOption) optionFunctions)
        (renameAttrs (name: _value: "mk${capitalize name}") optionFunctions)
      ];

    withDefault = defaultFs: mkOptionFunction: arg:
      let
        maybeOption = mkOptionFunction [ ];
      in
      if isFunction maybeOption then
        withDefault defaultFs (mkOptionFunction arg)
      else
        mkOptionFunction (defaultFs ++ arg)
      ;
  };
}
