{ nix-utils }:

let
  inherit (nix-utils)
    forEachAttr
    getExistingAttrs
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
}
