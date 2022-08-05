{ nix-utils }:

let
  inherit (nix-utils.lib)
    mkCpanUrl
  ;
in

{
  "mkCpanUrl" = {
    expr = mkCpanUrl "RCLAMP" "Devel-LexAlias" "0.05";
    expected = "mirror://cpan/authors/id/R/RC/RCLAMP/Devel-LexAlias-0.05.tar.gz";
  };
}
