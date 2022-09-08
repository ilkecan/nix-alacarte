{
  lib,
  ...
}:

let
  inherit (builtins)
    all
    getAttr
  ;

  inherit (lib)
    assertMsg
  ;

  inherit (lib.generators)
    toPretty
  ;

  toPretty' = toPretty { };
in

{
  allEnabled = all (cfg:
    assert assertMsg (cfg ? enable)
      "nix-alacarte.allEnabled: config is missing attribute `enable`\n${toPretty' cfg}";
    cfg.enable
  );
}
