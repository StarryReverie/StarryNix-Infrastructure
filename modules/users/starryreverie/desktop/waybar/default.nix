{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [
      waybar
      brightnessctl
      nerd-fonts.symbols-only
    ];

    file.xdg_config."waybar/config.jsonc".source = ./config.jsonc;
    file.xdg_config."waybar/style.css".source = ./style.css;
  };
}
