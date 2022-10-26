{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fn
  ;
in

{
  bool = {
    not = bool:
      !bool;

    toInt = fn.ternary' 1 0;

    toOnOff = fn.ternary' "on" "off";
  };
}
