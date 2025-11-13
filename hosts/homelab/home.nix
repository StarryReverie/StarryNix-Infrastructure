{
  config,
  lib,
  pkgs,
  constants,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/home/difftastic)
    (flakeRoot + /modules/home/direnv)
    (flakeRoot + /modules/home/git)
    (flakeRoot + /modules/home/systemctl-tui)
  ];

  home.username = constants.username;
  home.homeDirectory = "/home/${constants.username}";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
