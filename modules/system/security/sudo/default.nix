{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.security.sudo;
in
{
  config = lib.mkIf customCfg.enable {
    security.sudo-rs.enable = true;

    security.sudo-rs.execWheelOnly = true;

    security.sudo-rs.extraConfig = ''
      Defaults:%wheel timestamp_timeout=10
    '';
  };
}
