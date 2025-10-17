{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./editor.nix
    ./keybindings.nix
    ./themes.nix
  ];

  programs.helix.enable = true;

  programs.helix.settings.theme = "one-dark-transparent";
  programs.helix.defaultEditor = true;
}
