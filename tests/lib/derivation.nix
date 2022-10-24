{
  dnm,
  nix-alacarte,
  ...
}:

let
  inherit (nix-alacarte)
    addPassthru
    drv
  ;

  inherit (drv)
    makeOverridable
    source
  ;

  inherit (dnm)
    assertEqual
    assertFailure
  ;
in

{
  addPassthru = {
    new_attr = assertEqual {
      actual = addPassthru { test = true; } { passthru = { type = "derivation"; }; };
      expected = { passthru = { type = "derivation"; test = true; }; test = true; };
    };

    overwrite_attr = assertEqual {
      actual = addPassthru { type = "test"; } { passthru = { type = "derivation"; }; };
      expected = { passthru = { type = "test"; }; type = "test"; };
    };
  };

  makeOverridable =
    let
      inner = makeOverridable "inner"
        ({ a ? 1, b ? 2, c ? 3 }: { z = b * (a + c); });
      result =  inner { };
      middle = makeOverridable "middle" ({ x ? 0, y ? 4, z ? 1 }: inner { b = z * (y - x); });
      result' = middle { };
      outer = makeOverridable "outer" ({ k ? -2, l ? 7 }: middle { x = k + l; });
      result'' = outer { };
    in
    {
      function_must_return_an_attrs =
        assertFailure makeOverridable "add" ({ a, b }: a + b) { a = 1; b = 2; };

      single = {
        dont_override = assertEqual {
          actual = result.z;
          expected = 8;
        };

        override = assertEqual {
          actual = (result.override.inner { a = 4; }).z;
          expected = 14;
        };
      };

      nested = {
        dont_override = assertEqual {
          actual = result'.z;
          expected = 16;
        };

        override = {
          default = {
            accepts_attrs_of_override_args = assertEqual {
              actual = (result''.override { inner = { b = 3; }; }).z;
              expected = 12;
            };

            inner_has_precedence_over_outer = assertEqual {
              actual = (result''.override { inner = { b = 3; }; outer = { k = 8; }; }).z;
              expected = 12;
            };
          };

          outer = assertEqual {
            actual = (result''.override.outer { k = 8; }).z;
            expected = -44;
          };

          middle = assertEqual {
            actual = (result''.override.middle { y = 20; }).z;
            expected = 60;
          };

          inner = assertEqual {
            actual = (result''.override.inner { a = 3; }).z;
            expected = -6;
          };

          outer_outer = {
            overwrite = assertEqual {
              actual = ((result''.override.outer { k = 4; }).override.outer { k = 8; }).z;
              expected = -44;
            };

            different = assertEqual {
              actual = ((result''.override.outer { k = 8; }).override.outer { l = 11; }).z;
              expected = -60;
            };
          };

          outer_middle = assertEqual {
            actual = ((result''.override.outer { k = 8; }).override.middle { y = 20; }).z;
            expected = 20;
          };

          outer_inner = assertEqual {
            actual = ((result''.override.outer { k = 8; }).override.inner { a = 3; }).z;
            expected = -66;
          };

          middle_outer = assertEqual {
            actual = ((result''.override.middle { y = 20; }).override.outer { k = 8; }).z;
            expected = 20;
          };

          middle_middle = {
            overwrite = assertEqual {
              actual = ((result''.override.middle { y = 12; }).override.middle { y = 20; }).z;
              expected = 60;
            };

            different = assertEqual {
              actual = ((result''.override.middle { x = -3; }).override.middle { y = 20; }).z;
              expected = 92;
            };
          };

          middle_inner = assertEqual {
            actual = ((result''.override.middle { y = 20; }).override.inner { a = 3; }).z;
            expected = 90;
          };

          inner_outer = assertEqual {
            actual = ((result''.override.inner { a = 3; }).override.outer { k = 8; }).z;
            expected = -66;
          };

          inner_middle = assertEqual {
            actual = ((result''.override.inner { a = 3; }).override.middle { y = 20; }).z;
            expected = 90;
          };

          inner_inner = {
            overwrite = assertEqual {
              actual = ((result''.override.inner { a = 7; }).override.inner { a = 3; }).z;
              expected = -6;
            };

            different = assertEqual {
              actual = ((result''.override.inner { b = 4; }).override.inner { a = 3; }).z;
              expected = 24;
            };
          };

          inner_middle_outer_middle_outer_inner = assertEqual {
            actual = ((((((result''
              .override.inner { a = 7; })
              .override.middle { y = -2; })
              .override.outer { k = 12; })
              .override.middle { z = 6; })
              .override.outer { l = 3; })
              .override.inner { a = -8; })
              .z;
            expected = 510;
          };
        };
      };
    };

  source = {
    has_src_attr = assertEqual {
      actual = source { src = "<source-drv>"; };
      expected = "<source-drv>";
    };

    does_not_have_src_attr = assertEqual {
      actual = source "<flake-input>";
      expected = "<flake-input>";
    };
  };
}
