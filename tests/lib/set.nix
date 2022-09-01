{
  dnm,
  alacarte,
  ...
}:

let
  inherit (alacarte)
    forEachAttr
    getExistingAttrs
    partitionAttrs
    removeNullAttrs
    renameAttrs
    setAttr
    setAttrByPath'
  ;

  inherit (dnm)
    assertEqual
  ;
in

{
  forEachAttr = assertEqual {
    actual = forEachAttr { x = "foo"; y = "bar"; } (name: value:
      name + "-" + value
    );
    expected = { x = "x-foo"; y = "y-bar"; };
  };

  getExistingAttrs = assertEqual {
    actual = getExistingAttrs [ "y" "z" ] { x = "foo"; y = "bar"; };
    expected = { y = "bar"; };
  };

  partitionAttrs = assertEqual {
    actual = partitionAttrs (name: value: name != "foo" && value > 10) { foo = 12; bar = 20; };
    expected = { right = { bar = 20; }; wrong = { foo = 12; }; };
  };

  removeNullAttrs = assertEqual {
    actual = removeNullAttrs { a = false; b = null; c = 2; };
    expected = { a = false; c = 2; };
  };

  renameAttrs = assertEqual {
    actual = renameAttrs (name: value: "${name}-${toString value}") { a = 1; b = 2; };
    expected = { "a-1" = 1; "b-2" = 2; };
  };

  setAttr = {
    existing = assertEqual {
      actual = setAttr "existing" true { existing = false; };
      expected = { existing = true; };
    };

    new = assertEqual {
      actual = setAttr "new" true { existing = false; };
      expected = { existing = false; new = true; };
    };
  };

  setAttrByPath' = {
    depth_1 = assertEqual {
      actual = setAttrByPath' [ "top" ] true { top = false; other = "hey"; };
      expected = { top = true; other = "hey"; };
    };

    depth_3 = assertEqual {
      actual = setAttrByPath' [ "top" "middle" "bottom" ] 42 { top = { middle = { bottom = null; }; other = "hey"; }; };
      expected = { top = { middle = { bottom = 42; }; other = "hey"; }; };
    };
  };
}
