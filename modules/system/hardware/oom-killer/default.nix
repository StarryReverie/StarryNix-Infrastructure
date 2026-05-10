{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.oom-killer;
in
{
  config = lib.mkIf customCfg.enable {
    systemd.oomd.enable = true;

    systemd.oomd.enableRootSlice = true;
    systemd.oomd.enableSystemSlice = true;
    systemd.oomd.enableUserSlices = true;
  };
}
