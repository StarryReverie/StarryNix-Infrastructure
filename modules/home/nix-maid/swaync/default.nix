{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [ swaynotificationcenter ];

    file.xdg_config."swaync/config.json".source = ./config.json;
    file.xdg_config."swaync/style.css".source = ./style.css;
  };
}
