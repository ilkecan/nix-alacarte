{
  alacarte,
  lib,
  ...
}:

let
  inherit (builtins)
    mapAttrs
  ;

  inherit (lib)
    concat
    isType
  ;

  inherit (alacarte)
    capitalize
    compose
    mergeListOfAttrs
    renameAttrs
  ;

  inherit (alacarte.internal.options)
    mkOptionConstructor
    withDefault
  ;

  optionConstructorType = "option-constructor";
  isOptionConstructor = isType optionConstructorType;
  toOption = mkOptionFunction:
    if isOptionConstructor mkOptionFunction then
      mkOptionFunction [ ]
    else
      compose [ toOption mkOptionFunction ]
    ;
in

{
  options = {
    generateOptions = optionFunctions:
      mergeListOfAttrs [
        (mapAttrs (_name: toOption) optionFunctions)
        (renameAttrs (name: _value: "mk${capitalize name}") optionFunctions)
      ];

    mkOptionConstructor = unaryFunction:
      {
        _type = optionConstructorType;
        __functor = _self: unaryFunction;
      };

    withDefault = defaultFs: mkOptionFunction:
      if isOptionConstructor mkOptionFunction then
        mkOptionConstructor (compose [ mkOptionFunction (concat defaultFs) ])
      else
        compose [ (withDefault defaultFs) mkOptionFunction ]
      ;
  };
}
