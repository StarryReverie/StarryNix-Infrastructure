{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [ alacritty ];

    file.xdg_config."alacritty/alacritty.toml".source = ./alacritty.toml;
  };
}
