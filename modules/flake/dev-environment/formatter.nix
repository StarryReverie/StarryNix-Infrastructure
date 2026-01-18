{
  config,
  inputs,
  self,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
