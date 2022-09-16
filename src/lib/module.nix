{
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    all
  ;

  inherit (nix-alacarte.internal)
    assertAttr
  ;
in

{
  allEnabled = all (cfg:
    assert assertAttr "allEnabled" cfg "enable";
    cfg.enable
  );
}
