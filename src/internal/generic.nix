{
  ...
}:

{
  generic = {
    withDefaultFns = defaultFns: {
      bool ? null,
      float ? null,
      int ? null,
      lambda ? null,
      list ? null,
      null ? null,
      path ? null,
      set ? null,
      string ? null,
    }@fns:
      defaultFns // fns;
  };
}
