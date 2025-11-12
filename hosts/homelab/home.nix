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
    (flakeRoot + /modules/home/bat)
    (flakeRoot + /modules/home/difftastic)
    (flakeRoot + /modules/home/direnv)
    (flakeRoot + /modules/home/eza)
    (flakeRoot + /modules/home/fastfetch)
    (flakeRoot + /modules/home/fd)
    (flakeRoot + /modules/home/fzf)
    (flakeRoot + /modules/home/git)
    (flakeRoot + /modules/home/helix)
    (flakeRoot + /modules/home/lazygit)
    (flakeRoot + /modules/home/ripgrep)
    (flakeRoot + /modules/home/systemctl-tui)
    (flakeRoot + /modules/home/zellij)
    (flakeRoot + /modules/home/zoxide)
    (flakeRoot + /modules/home/zsh)
  ];

  home.username = constants.username;
  home.homeDirectory = "/home/${constants.username}";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
