{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.cpuScheduler;
in
{
  config = lib.mkIf customCfg.enable {
    services.scx-loader.enable = true;

    services.scx-loader.config.default_sched = "scx_lavd";
  };
}
