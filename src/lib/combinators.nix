{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (lib)
    isFunction
  ;

  inherit (nix-alacarte)
    fn
    list
  ;

  inherit (nix-alacarte.internal)
    booleanCombinator
  ;
in

{
  combinators = {
    mkCombinator = combineFunc:
      let
        self = fs:
          if isFunction (list.head fs) then
            val:
              self (list.map (fn.callWith val) fs)
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
