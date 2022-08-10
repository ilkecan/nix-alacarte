{
  lib,
  nix-utils,
  ...
}:

{
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
