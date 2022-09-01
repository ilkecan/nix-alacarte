{
  lib,
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    all
    any
    head
    length
  ;

  inherit (lib)
    id
    isFunction
  ;

  inherit (nix-alacarte)
    combinators
    callWith
  ;

  booleanCombinator = f:
    combinators.mkCombinator (f id);
in

{
  combinators = {
    mkCombinator = combineFunc:
      let
        self = fs:
          if isFunction (head fs) then
            val:
              self (map (callWith val) fs)
          else
            combineFunc fs
          ;
      in
      list:
        if length list == 0 then
          combineFunc [ ]
        else
          self list
        ;

    and = booleanCombinator all;
    or = booleanCombinator any;
  };
}
