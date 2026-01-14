{
  config,
  inputs,
  withSystem,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
