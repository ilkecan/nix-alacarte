{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    bool
    fn
  ;

  inherit (nix-alacarte.internal)
    assertion
  ;

  self = bool;
in

{
  bool =
    let
      assertion' = assertion.appendScope "bool";
    in
    {
      and = left: right:
        left && right;

      nand = left:
        fn.compose [ self.not (self.and left) ];

      nor = left:
        fn.compose [ self.not (self.or left) ];

      not = bool:
        !bool;

      or = left: right:
        left || right;

      toInt = fn.ternary' 1 0;

      toOnOff = fn.ternary' "on" "off";

      xnor = left:
        fn.compose [ self.not (self.xor left) ];

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
