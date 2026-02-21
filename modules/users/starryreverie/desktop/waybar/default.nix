{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.waybar or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        waybar
        brightnessctl
        nerd-fonts.symbols-only
      ];

      file.xdg_config."waybar/config.jsonc".source = ./config.jsonc;
      file.xdg_config."waybar/style.css".source = ./style.css;
    };
  };
}
