{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [ rofi ];

    file.xdg_config."rofi/config.rasi".source = ./config.rasi;
  };
}
