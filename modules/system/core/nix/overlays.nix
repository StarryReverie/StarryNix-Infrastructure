{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = lib.attrsets.attrValues inputs.self.overlays;
}
