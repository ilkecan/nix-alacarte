{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    allEnabled
  ;

  inherit (dnm)
    assertFailure
    assertFalse
    assertTrue
  ;
in

{
  allEnabled = {
    all_configs_enabled = assertTrue allEnabled [ { enable = true; } { enable = true; } ];
    some_configs_enabled = assertFalse allEnabled [ { enable = true; } { enable = false; } ];
    config_missing_enable = assertFailure allEnabled [ { enble = true; } { } ];
  };
}
