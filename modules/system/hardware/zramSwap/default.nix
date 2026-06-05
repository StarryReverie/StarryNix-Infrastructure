{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.zramSwap;
in
{
  config = lib.mkIf customCfg.enable {
    zramSwap.enable = true;
    zramSwap.memoryPercent = 200;
  };
}
