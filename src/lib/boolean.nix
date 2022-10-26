{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    fn
  ;

  inherit (nix-alacarte.internal)
    assertion
  ;
in

{
  bool =
    let
      assertion' = assertion.appendScope "bool";
    in
    {
      and = left: right:
        left && right;

      not = bool:
        !bool;

      or = left: right:
        left || right;

      toInt = fn.ternary' 1 0;

      toOnOff = fn.ternary' "on" "off";

      xor =
        let
          assertion'' = assertion'.appendScope "xor";
        in
        left: right:
        assert assertion''.type "bool" "left" left;
        assert assertion''.type "bool" "right" right;
          left != right;
    };
}
