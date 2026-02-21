{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.alacritty or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ alacritty ];

      file.xdg_config."alacritty/alacritty.toml".source = ./alacritty.toml;
    };
  };
}
