{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    bool
    mkMerge
    mkMergeMany
    mkToString
  ;

  inherit (dnm)
    assertEqual
    assertFailure
    assertNull
  ;
in

{
  mkMerge =
    let
      merge = mkMerge { };
    in
    {
      missing_merge_function = assertFailure merge 4 65;
      mismatched_type = assertFailure merge [ 24 ] { a = 4; };

      default = {
        list = assertEqual {
          actual = merge [ 24 ] [ 3 56 ];
          expected = [ 24 3 56 ];
        };

        null = assertNull merge null null;

        set = assertEqual {
          actual = merge { a = [ 24 ]; b = { c = 2; }; } { a = [ 3 56 ]; b = { d = 5; }; };
          expected = { a = [ 24 3 56 ]; b = { c = 2; d = 5; }; };
        };
      };

      custom = assertEqual {
        actual = mkMerge { bool = bool.xor; } true false;
        expected = true;
      };
    };

  mkMergeMany =
    let
      mergeMany = mkMergeMany { };
    in
    {
      empty = assertNull mergeMany [ ];
      mismatched_type = assertFailure mergeMany [ [ 24 ] { a = 4; } ];
      missing_mergeMany_function = assertFailure mergeMany [ 4 65 ];
      singleton = assertEqual {
        actual = mergeMany [ 23.5 ];
        expected = 23.5;
      };

      default = {
        list = assertEqual {
          actual = mergeMany [ [ 24 ] [ 3 56 ] [ 72 ] ];
          expected = [ 24 3 56 72 ];
        };

        null = assertNull mergeMany [ null ];

        set = assertEqual {
          actual = mergeMany [
            { a = [ 24 ]; b = { c = 2; }; }
            { a = [ 3 56 ]; b = { d = 5; }; }
            { b = { e = -3; }; }
          ];
          expected = { a = [ 24 3 56 ]; b = { c = 2; d = 5; e = -3; }; };
        };
      };

      custom = assertEqual {
        actual = mkMergeMany { bool = bool.xor; } [ true false true ];
        expected = false;
      };
    };

  mkToString = {
    default = assertEqual {
      actual = mkToString { } true;
      expected = "1";
    };

    custom = assertEqual {
      actual = mkToString { bool = v: if v then "yes" else "no"; } true;
      expected = "yes";
    };
  };
}
