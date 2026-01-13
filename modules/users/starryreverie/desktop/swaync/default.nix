{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [ swaynotificationcenter ];

    file.xdg_config."swaync/config.json".source = ./config.json;
    file.xdg_config."swaync/style.css".source = ./style.css;
  };
}
