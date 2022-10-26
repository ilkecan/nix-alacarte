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
    and = left: right:
      left && right;

    not = bool:
      !bool;

    or = left: right:
      left || right;

    toInt = fn.ternary' 1 0;

    toOnOff = fn.ternary' "on" "off";
  };
}
