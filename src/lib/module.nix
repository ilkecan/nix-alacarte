{
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    all
  ;

  inherit (nix-alacarte.internal)
    throw'
  ;
in

{
  allEnabled =
    let
      throw'' = throw'.appendScope "allEnabled";
      missingAttribute = throw''.missingAttribute "enable";
    in
    all (cfg:
      cfg.enable or (missingAttribute cfg)
    );
}
