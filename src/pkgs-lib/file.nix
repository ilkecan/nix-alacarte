{
  nix-alacarte,
  pkgs,
  ...
}:

let
  inherit (nix-alacarte.internal.file)
    add
  ;
in

{
  file = {
    append = add true;

    concat = pkgs.concatText;

    prepend = add false;

    write = pkgs.writeTextFile;
  };
}
