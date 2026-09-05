{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.desktop.environment-gnome;
in
{
  config = lib.mkIf customCfg.enable {
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = [
      pkgs.gnome-tour
      pkgs.gnome-user-docs
    ];

    environment.systemPackages = with pkgs.gnomeExtensions; [
      appindicator
      caffeine
      just-perfection
      kimpanel
    ];
  };
}
