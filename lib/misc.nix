{
  lib,
  nix-utils,
  ...
}:

{
  callWith = val: f:
    f val;

  isNull = value:
    value == null;

  notNull = value:
    value != null;

  optionalValue = condition: value:
    if condition then
      value
    else
      null
    ;
}
