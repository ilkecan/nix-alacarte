{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    id
    isFunction
  ;

  inherit (nix-alacarte)
    callWith
    combinators
    list
  ;

  booleanCombinator = f:
    combinators.mkCombinator (f id);
in

{
  combinators = {
    mkCombinator = combineFunc:
      let
        self = fs:
          if isFunction (list.head fs) then
            val:
              self (map (callWith val) fs)
          else
            combineFunc fs
          ;
      in
      list':
        if list.length list' == 0 then
          combineFunc [ ]
        else
          self list'
        ;

    and = booleanCombinator list.all;
    or = booleanCombinator list.any;
  };
}
