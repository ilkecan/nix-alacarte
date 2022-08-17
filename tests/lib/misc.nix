{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    callWith
    equals
    isNull
    notEquals
    notNull
  ;
in

{
  "callWith" = {
    expr = callWith 5 (n: n + 10);
    expected = 15;
  };

  "equals_true" = {
    expr = equals 2 2;
    expected = true;
  };

  "equals_false" = {
    expr = equals "a" "b";
    expected = false;
  };

  "notEquals_true" = {
    expr = notEquals [ 2 ] 2;
    expected = true;
  };

  "notEquals_false" = {
    expr = notEquals { v = 2; } { v = 2; };
    expected = false;
  };

  "isNull_true" = {
    expr = isNull null;
    expected = true;
  };

  "isNull_false" = {
    expr = isNull true;
    expected = false;
  };

  "notNull_true" = {
    expr = notNull 4.2;
    expected = true;
  };

  "notNull_false" = {
    expr = notNull null;
    expected = false;
  };
}
