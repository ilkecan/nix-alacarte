{
  dnm,
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    isAbsolutePath
  ;

  inherit (dnm)
    assertFalse
    assertTrue
  ;
in

{
  isAbsolutePath = {
    path = assertTrue (isAbsolutePath ./data);
    string_absolute = assertTrue (isAbsolutePath "/var/root");
    string_relative = assertFalse (isAbsolutePath ".git/config");
  };
}
