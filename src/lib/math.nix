{
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    even
    math
    negate
    negative
    recip
  ;

  self = math;
in

{
  math = {
    pow = base: exponent:
      let
        self = base: exponent:
          if exponent == 0
            then 1
          else if even exponent
            then self (base * base) (exponent / 2)
          else base * (self (base * base) (exponent / 2)); 
      in
      if negative exponent
        then self (recip base) (negate exponent)
        else self base exponent;
  };
}
