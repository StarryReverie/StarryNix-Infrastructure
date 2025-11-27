{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./extensions.nix
    ./security.nix
  ];

  programs.firefox.enable = true;
}
