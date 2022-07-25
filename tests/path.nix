{ nix-utils }:

let
  inherit (nix-utils)
    isAbsolutePath
  ;
in

{
  "isAbsolutePath_path" = {
    expr = isAbsolutePath ./data;
    expected = true;
  };

  "isAbsolutePath_string_true" = {
    expr = isAbsolutePath "/var/root";
    expected = true;
  };

  "isAbsolutePath_string_false" = {
    expr = isAbsolutePath ".git/config";
    expected = false;
  };
}
