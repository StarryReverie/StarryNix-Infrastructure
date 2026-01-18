{ inputs, pkgs, ... }:
{
  paths = with pkgs; [
    difftastic
    direnv
    helix
    htop
    lazygit
    zellij
    yazi-unwrapped
    nixfmt
    nixfmt-tree
  ];
}
