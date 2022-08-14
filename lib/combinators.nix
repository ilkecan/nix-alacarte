{
  lib,
  nix-utils,
  ...
}:

let
  inherit (builtins)
    all
    any
    head
  ;

  inherit (lib)
    id
    isFunction
  ;

  inherit (nix-utils)
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
      self;

    and = booleanCombinator all;
    or = booleanCombinator any;
  };
}
