{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [ alacritty ];

    file.xdg_config."alacritty/alacritty.toml".source = ./alacritty.toml;
  };
}
