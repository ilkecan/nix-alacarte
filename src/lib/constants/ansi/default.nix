{
  nix-alacarte,
  ...
}:

let
  inherit (builtins)
    typeOf
  ;

  inherit (nix-alacarte)
    attrs
    increment
    list
    pair
    pipe'
    uncommands
  ;

  inherit (nix-alacarte.ascii)
    controlCharacters
  ;

  inherit (nix-alacarte.ansi.controlFunctions)
    C0
    controlSequences
  ;

  inherit (nix-alacarte.internal)
    assertion
  ;

  inherit (controlSequences)
    SGR
  ;

  mkSgrColor =
    let
      assertion' = assertion.appendScope "mkSgrColor";
    in
    {
      background ? false,
      bit ? 8,
    }:
    assert assertion'.oneOf [ 8 24 ] "bit" bit;
    let
      typeParameter = if background then 48 else 38;
      bitParamater = {
        "8" = 5;
        "24" = 2;
      }.${toString bit};
    in
    pipe' [
      (list.prepend [ typeParameter bitParamater ])
      SGR.mkSequence
    ];
in

{
  ansi = {
    controlFunctions = {
      C0 = controlCharacters;
      C1 = import ./C1.nix;

      controlSequences = {
        # https://www.ecma-international.org/wp-content/uploads/ECMA-48_5th_edition_june_1991.pdf#page=75
        mkSequence = final:
          pipe' [
          (list.map toString)
          uncommands
          # use the two-character `ESC [` sequence instead of the 8-bit C1 CSI
          # code to work in UTF-8 environments
          (s: "${C0.ESC}[${s}${final}")
        ];

        SGR =
          let
            f = attrs.map (_: value:
              {
                set = f value;
                int = SGR.mkSequence [ value ];
                lambda = value;
              }.${typeOf value}
            );
          in
          f {
            mkSequence = controlSequences.mkSequence "m";

            reset = 0 ;
            bold = 1;
            faint = 2;
            italic = 3;
            underline = 4;
            slowBlink = 5;
            rapidBlink = 6;
            negativeImage = 7;
            conceal = 8;
            strike = 9;
            font = {
              primary = 10;
            } // list.mapToAttrs
              (i: pair "alternative${toString i}" (10 + i))
              (list.gen increment 9);
            fraktur = 20;
            doubleUnderline = 21;
            resetIntensity = 22;
            resetItalicAndFraktur = 23;
            resetUnderline = 24;
            steady = 25;
            proportionalSpacing = 26;
            positiveImage = 27;
            reveal = 28;
            resetStrike = 29;
            black = 30;
            red = 31;
            green = 32;
            yellow = 33;
            blue = 34;
            magenta = 35;
            cyan = 36;
            white = 37;
            # 38: Set foreground color. Next arguments are 5;n or 2;r;g;b
            mk8BitColor = mkSgrColor { };
            mk24BitColor = mkSgrColor { bit = 24; };
            defaultColor = 39;
            background = {
              black = 40;
              red = 41;
              green = 42;
              yellow = 43;
              blue = 44;
              magenta = 45;
              cyan = 46;
              white = 47;
              # 48: Set background color. Next arguments are 5;n or 2;r;g;b
              mk8BitColor = mkSgrColor { background = true; };
              mk24BitColor = mkSgrColor { background = true; bit = 24; };
              default = 49;
            };
            disableProportionalSpacing = 50;
            frame = 51;
            encircle = 52;
            overline = 53;
            resetFrameAndEncircle = 54;
            resetOverline = 55;
            # 56 reserved for future
            # 57 reserved for future
            # 58 reserved for future
            # 59 reserved for future
            ideogram = {
              underline = 60;
              doubleUnderline = 61;
              overline = 62;
              doubleOverline = 63;
              stress = 64;
              reset = 65;
            };
          };
      };
    };
  };
}
