{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.desktop.screenLocker;
in
{
  config = lib.mkIf customCfg.enable {
    security.pam.services.hyprlock = { };
  };
}
