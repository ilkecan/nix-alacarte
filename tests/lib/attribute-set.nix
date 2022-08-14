{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    forEachAttr
    getExistingAttrs
    partitionAttrs
    removeNullAttrs
    renameAttrs
    setAttr
    setAttrByPath'
  ;
in

{
  "forEachAttr" = {
    expr = forEachAttr { x = "foo"; y = "bar"; } (name: value:
      name + "-" + value
    );
    expected = { x = "x-foo"; y = "y-bar"; };
  };

  "getExistingAttrs" = {
    expr = getExistingAttrs [ "y" "z" ] { x = "foo"; y = "bar"; };
    expected = { y = "bar"; };
  };

  "partitionAttrs" = {
    expr = partitionAttrs (name: value: name != "foo" && value > 10) { foo = 12; bar = 20; };
    expected = { right = { bar = 20; }; wrong = { foo = 12; }; };
  };

  "removeNullAttrs" = {
    expr = removeNullAttrs { a = false; b = null; c = 2; };
    expected = { a = false; c = 2; };
  };

  "renameAttrs" = {
    expr = renameAttrs (name: value: "${name}-${toString value}") { a = 1; b = 2; };
    expected = { "a-1" = 1; "b-2" = 2; };
  };

  "setAttr_existing" = {
    expr = setAttr "existing" true { existing = false; };
    expected = { existing = true; };
  };

  "setAttr_new" = {
    expr = setAttr "new" true { existing = false; };
    expected = { existing = false; new = true; };
  };

  "setAttrByPath'" = {
    expr = setAttrByPath' [ "top" ] true { top = false; other = "hey"; };
    expected = { top = true; other = "hey"; };
  };

  "setAttrByPath'_nested" = {
    expr = setAttrByPath' [ "top" "middle" "bottom" ] 42 { top = { middle = { bottom = null; }; other = "hey"; }; };
    expected = { top = { middle = { bottom = 42; }; other = "hey"; }; };
  };
}
