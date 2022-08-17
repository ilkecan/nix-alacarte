{
  nix-utils,
  ...
}:

let
  inherit (builtins)
    isFunction
    mapAttrs
  ;

  inherit (nix-utils)
    capitalize
    renameAttrs
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
    withDefault = defaultFs: mkF: fs:
      mkF (defaultFs ++ fs);

    generateOptions = optionFunctions:
      mapAttrs (_name: toOption) optionFunctions
      // renameAttrs (name: _value: "mk${capitalize name}") optionFunctions;
  };
}
