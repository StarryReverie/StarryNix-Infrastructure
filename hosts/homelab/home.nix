{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  home.username = constants.username;
  home.homeDirectory = "/home/${constants.username}";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
