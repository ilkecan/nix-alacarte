{
  ...
}:

{
  __functor = _:
    start: end:
      { inherit start end; };

  contains = element: { start, end }:
    start <= element && element < end;

  empty = { start, end }:
    start >= end;

  toString = { start, end }:
    let
      start' = toString start;
      end' = toString end;
    in
    "[${start'}, ${end'})";
}
