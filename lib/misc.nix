{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    equals
    notEquals
  ;
in

{
  callWith = val: f:
    f val;

  equals = lhs: rhs:
    lhs == rhs;
  notEquals = lhs: rhs:
    lhs != rhs;

  isNull = equals null;
  notNull = notEquals null;

  optionalValue = condition: value:
    if condition then
      value
    else
      null
    ;
}
