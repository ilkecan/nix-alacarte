{
  dnm,
  alacarte,
  ...
}:

let
  inherit (alacarte)
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
