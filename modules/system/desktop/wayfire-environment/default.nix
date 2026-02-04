{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.desktop.wayfire-environment;
in
{
  config = lib.mkIf customCfg.enable {
    programs.wayfire.enable = true;
  };
}
