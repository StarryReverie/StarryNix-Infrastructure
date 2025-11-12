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
    (flakeRoot + /modules/home/atuin)
    (flakeRoot + /modules/home/difftastic)
    (flakeRoot + /modules/home/direnv)
    (flakeRoot + /modules/home/eza)
    (flakeRoot + /modules/home/fzf)
    (flakeRoot + /modules/home/git)
    (flakeRoot + /modules/home/systemctl-tui)
    (flakeRoot + /modules/home/zoxide)
    (flakeRoot + /modules/home/zsh)
  ];

  home.username = constants.username;
  home.homeDirectory = "/home/${constants.username}";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
