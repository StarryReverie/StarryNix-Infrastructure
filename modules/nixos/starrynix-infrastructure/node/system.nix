{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/headless.nix")
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/perlless.nix")
  ];

  nix.enable = false;
}
