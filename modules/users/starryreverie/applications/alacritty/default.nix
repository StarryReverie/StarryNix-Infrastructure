{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.alacritty;
in
{
  config = lib.mkIf customCfg.enable {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ alacritty ];

      file.xdg_config."alacritty/alacritty.toml".source = ./alacritty.toml;
    };
  };
}
