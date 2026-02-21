{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.rofi or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ rofi ];

      file.xdg_config."rofi/config.rasi".source = ./config.rasi;
    };
  };
}
