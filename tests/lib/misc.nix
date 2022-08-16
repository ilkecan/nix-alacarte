{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    callWith
    isNull
    notNull
  ;
in

{
  "callWith" = {
    expr = callWith 5 (n: n + 10);
    expected = 15;
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
