{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.swaync or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ swaynotificationcenter ];

      file.xdg_config."swaync/config.json".source = ./config.json;
      file.xdg_config."swaync/style.css".source = ./style.css;
    };
  };
}
