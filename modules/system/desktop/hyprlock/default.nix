{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.desktop.hyprlock;
in
{
  config = lib.mkIf customCfg.enable {
    security.pam.services.hyprlock = { };
  };
}
