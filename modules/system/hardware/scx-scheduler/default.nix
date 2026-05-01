{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.scx-scheduler;
in
{
  config = lib.mkIf customCfg.enable {
    services.scx.enable = true;
    services.scx.package = pkgs.scx.rustscheds;

    services.scx.scheduler = "scx_lavd";
  };
}
