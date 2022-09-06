{
  ...
}:

{
  callWith = val: f:
    f val;

  equals = lhs: rhs:
    lhs == rhs;
  notEquals = lhs: rhs:
    lhs != rhs;

  optionalValue = condition: value:
    if condition then
      value
    else
      null
    ;
}
