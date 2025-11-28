{
  config,
  lib,
  pkgs,
  ...
}:
{
  wrappers.waybar.basePackage = pkgs.waybar;

  wrappers.waybar.prependFlags = [
    "--config=${./config.jsonc}"
    "--style=${./style.css}"
  ];

  wrappers.waybar.pathAdd = with pkgs; [
    nerd-fonts.symbols-only
    brightnessctl
  ];
}
