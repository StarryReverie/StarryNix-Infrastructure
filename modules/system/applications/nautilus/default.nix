{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.applications.nautilus;
in
{
  config = lib.mkIf customCfg.enable {
    environment.systemPackages = with pkgs; [ nautilus ];

    services.gvfs.enable = true;

    services.gnome.sushi.enable = true;

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };
  };
}
