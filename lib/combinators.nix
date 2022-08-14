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
    let
      self = fs:
        if isFunction (head fs) then
          val:
            self (map (callWith val) fs)
        else
          f id fs
        ;
    in
    self;
in

{
  combinators = {
    and = booleanCombinator all;
    or = booleanCombinator any;
  };
}
