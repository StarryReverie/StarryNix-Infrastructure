{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./theme.nix
  ];

  programs.eza.enable = true;

  programs.eza.icons = "never";
  programs.eza.extraOptions = [
    "--group-directories-first"
    "--no-git"
    "--binary"
    "--group"
    "--time-style=long-iso"
  ];

  home.shellAliases = {
    ls = "eza";
    la = "eza --all --all";
    ll = "eza --long";
    lla = "eza --long --all --all";
    tree = "eza --tree";
  };
}
