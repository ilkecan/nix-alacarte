{
  lib,
  nix-utils,
  ...
}:

{
  optionalValue = condition: value:
    if condition then
      value
    else
      null
    ;
}
