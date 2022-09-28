{
  ...
}:

{
  equalTo = rhs: lhs:
    lhs == rhs;

  greaterThan = rhs: lhs:
    lhs > rhs;

  greaterThanOrEqualTo = rhs: lhs:
    lhs >= rhs;

  lessThan = rhs: lhs:
    lhs < rhs;

  lessThanOrEqualTo = rhs: lhs:
    lhs <= rhs;

  notEqualTo = rhs: lhs:
    lhs != rhs;
}
